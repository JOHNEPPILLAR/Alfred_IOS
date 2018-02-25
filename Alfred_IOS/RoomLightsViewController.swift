//
//  RoomLightsViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 28/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class RoomLightsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, colorPickerDelegate, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!) )
    }
    var roomLightsData = [RoomLightsBaseClass]()
    var refreshDataTimer: Timer!
    let timerInterval = 5
    
    @IBOutlet weak var LightTableViewRooms: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")
        
        self.LightTableViewRooms.rowHeight = 80.0
        refreshDataLoad()
        
        refreshDataTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timerInterval), target: self, selector: (#selector(refreshDataLoad)), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshDataTimer.invalidate() // Stop the refresh data timer
        SVProgressHUD.dismiss() // Stop spinner
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (roomLightsData.count) > 0 {
            return (roomLightsData[0].data!.count)
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "lightCell", for: indexPath) as! LightsTableViewCell
        let row = indexPath.row

        cell.tag = row
        cell.lightName.text = roomLightsData[0].data![row].name
        
        // Configure the power button
        if (roomLightsData[0].data![row].state?.anyOn)! {

            // Setup the light bulb colour
            var color = UIColor.white
            switch roomLightsData[0].data![row].action?.colormode {
            case "ct"?: color = HueColorHelper.getColorFromScene((roomLightsData[0].data![row].action?.ct)!)
            case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((roomLightsData[0].data![row].action?.xy![0])!), y: Double((roomLightsData[0].data![row].action?.xy![1])!)), forModel: "LCT007")
            default: color = UIColor.white
            }
            cell.powerButton.backgroundColor = color
            cell.brightnessSlider.isHidden = false
        } else {
            cell.powerButton.backgroundColor = UIColor.clear
            cell.brightnessSlider.isHidden = true
        }
        
        cell.powerButton.tag = row
        cell.powerButton.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(powerButtonValueChange(_:)))
        cell.powerButton.addGestureRecognizer(tapRecognizer)
        let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPowerButtonPress(_:)))
        cell.powerButton.addGestureRecognizer(longTapRecognizer)

        cell.brightnessSlider.value = Float((roomLightsData[0].data![row].action?.bri)!)
        cell.brightnessSlider.tag = row
        cell.brightnessSlider?.addTarget(self, action: #selector(brightnessValueChange(slider:event:)), for: .valueChanged)

        return cell
    }

    @objc func brightnessValueChange(slider: UISlider, event: UIEvent) {
        slider.setValue(slider.value.rounded(.down), animated: true)
      
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                refreshDataTimer.invalidate() // Stop the refresh data timer
            case .ended:
                
                // Figure out which row is being updated
                let row = slider.tag
                
                // Update local data store
                roomLightsData[0].data![row].action?.bri = Int(slider.value)
                let lightID = roomLightsData[0].data![row].id
                
                // Call Alfred to update the light group
                let body: [String: Any] = ["light_number": lightID!, "brightness": Int(self.roomLightsData[0].data![row].action!.bri!)]
                let APIbody: Data = try! JSONSerialization.data(withJSONObject: body, options: [])
                let request = putAPIHeaderData(url: "lights/lightgroupbrightness", body: APIbody, useScheduler: false)
                let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
                let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                    if !checkAPIData(apiData: data, response: response, error: error) {
                        // Show error
                        DispatchQueue.main.async {
                            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                            SVProgressHUD.showError(withStatus: "Unable to update the light settings")
                        }
                    } else {
                        self.refreshDataTimer = Timer.scheduledTimer(timeInterval: TimeInterval(self.timerInterval), target: self, selector: (#selector(self.refreshDataLoad)), userInfo: nil, repeats: true)
                    }
                })
                task.resume()
            default:
                break
            }
        }
    }
    
    @objc func powerButtonValueChange(_ sender: UITapGestureRecognizer!) {
        
        refreshDataTimer.invalidate() // Stop the refresh data timer

        // Figure out which row is being updated
        let touch = sender.location(in: LightTableViewRooms)
        let indexPath = LightTableViewRooms.indexPathForRow(at: touch)
        let row = indexPath!.row
        let cell = LightTableViewRooms.cellForRow(at: indexPath!) as! LightsTableViewCell
        let lightID = roomLightsData[0].data![row].id

        var lightsOn: String
        
        if (roomLightsData[0].data![row].state?.anyOn)! {
            roomLightsData[0].data![row].state?.anyOn = false
            lightsOn = "off"
            cell.brightnessSlider.isHidden = true
            cell.powerButton.backgroundColor = UIColor.clear
        } else {
            cell.brightnessSlider.isHidden = false
            roomLightsData[0].data![row].state?.anyOn = true
            lightsOn = "on"

            // Setup the light bulb colour
            var color: UIColor
            switch roomLightsData[0].data![row].action?.colormode {
            case "ct"?: color = HueColorHelper.getColorFromScene((roomLightsData[0].data![row].action?.ct)!)
            case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((roomLightsData[0].data![row].action?.xy![0])!), y: Double((roomLightsData[0].data![row].action?.xy![1])!)), forModel: "LCT007")
            // Add hs as mode
            default: color = UIColor.white
            }
            cell.powerButton.backgroundColor = color
        }
        
        // Call Alfred to update the light group
        let body: [String: Any] = ["light_number": lightID!, "light_status": lightsOn, "brightness": self.roomLightsData[0].data![row].action!.bri!]
        let APIbody: Data = try! JSONSerialization.data(withJSONObject: body, options: [])
        let request = putAPIHeaderData(url: "lights/lightgrouponoff", body: APIbody, useScheduler: false)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if !checkAPIData(apiData: data, response: response, error: error) {
                // Show error
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showError(withStatus: "Unable to update the light settings")
                }
            } else {
                self.refreshDataTimer = Timer.scheduledTimer(timeInterval: TimeInterval(self.timerInterval), target: self, selector: (#selector(self.refreshDataLoad)), userInfo: nil, repeats: true)
            }
        })
        task.resume()
    }
    
    @objc func longPowerButtonPress(_ sender: UITapGestureRecognizer!) {
        
        refreshDataTimer.invalidate() // Stop the refresh data timer

        // Only do when finished long press
        if sender.state == .ended {
            
            // Figure out which cell is being updated
            let touch = sender.location(in: LightTableViewRooms)
            let indexPath = LightTableViewRooms.indexPathForRow(at: touch)
            let row = indexPath?.row
            let cell = LightTableViewRooms.cellForRow(at: indexPath!) as! LightsTableViewCell
            cellID.sharedInstance.cell = cell

            // Store the color
            var color = UIColor.white
            switch roomLightsData[0].data![row!].action?.colormode {
            case "ct"?: color = HueColorHelper.getColorFromScene((roomLightsData[0].data![row!].action!.ct)!)
            case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((roomLightsData[0].data![row!].action!.xy![0])), y: Double((roomLightsData[0].data![row!].action!.xy![1]))), forModel: "LCT007")
                default: color = UIColor.white
            }

            // Open the color picker
            performSegue(withIdentifier: "roomsShowColor", sender: color)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondViewController = segue.destination as! ColorViewController
        secondViewController.delegate = self
        secondViewController.colorID = sender as? UIColor
    }
    
    func backFromColorPicker(_ newColor: UIColor?, ct: Int?, scene: Bool?) {
        
        let cell = cellID.sharedInstance.cell // Update the button background
        let row = cell!.powerButton.tag
        let lightID = roomLightsData[0].data![row].id

        // Setup the local vars and the post to api data
        var lightsOn = "off"
        if (roomLightsData[0].data![row].state?.anyOn)! {
            lightsOn = "on"
        }
        var body: [String: Any] = ["light_number": lightID as Any, "light_status": lightsOn, "brightness": self.roomLightsData[0].data![row].action!.bri!]

        if scene! {
            // Color selected from scene list
            roomLightsData[0].data![row].action!.ct = ct
            roomLightsData[0].data![row].action!.colormode = "ct"
            cell!.powerButton.backgroundColor = HueColorHelper.getColorFromScene(ct!)
            body["ct"] = ct!
        } else {
            // Color seclected from color pallet
            let xy = HueColorHelper.calculateXY(newColor!, forModel: "LST007")
            roomLightsData[0].data![row].action!.xy = [Float(xy.x), Float(xy.y)]
            roomLightsData[0].data![row].action!.colormode = "xy"
            cell!.powerButton.backgroundColor = newColor
            body["x"] = xy.x
            body["y"] = xy.y
        }

        // Call API
        let APIbody: Data = try! JSONSerialization.data(withJSONObject: body, options: [])
        let request = putAPIHeaderData(url: "lights/lightgrouponoff", body: APIbody, useScheduler: false)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if !checkAPIData(apiData: data, response: response, error: error) {
                DispatchQueue.main.async {
                    // Show error
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showError(withStatus: "Unable to update the light settings")
                }
            } else {
                self.refreshDataTimer = Timer.scheduledTimer(timeInterval: TimeInterval(self.timerInterval), target: self, selector: (#selector(self.refreshDataLoad)), userInfo: nil, repeats: true)
            }
        })
        task.resume()
    }
    
    @IBAction func turnOffAllLights(recognizer:UIPanGestureRecognizer) {
        
        refreshDataTimer.invalidate() // Stop the refresh data timer

        // Call API
        let request = getAPIHeaderData(url: "lights/alloff", useScheduler: false)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if !checkAPIData(apiData: data, response: response, error: error) {
                // Show error
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showError(withStatus: "Unable to update the light settings")
                }
            } else {
                self.refreshDataTimer = Timer.scheduledTimer(timeInterval: TimeInterval(self.timerInterval), target: self, selector: (#selector(self.refreshDataLoad)), userInfo: nil, repeats: true)
            }
        })
        task.resume()
    }
    
    @objc func refreshDataLoad() {
        let request = getAPIHeaderData(url: "lights/listlightgroups", useScheduler: false)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = JSON(data: data!)
                self.roomLightsData = [RoomLightsBaseClass]() // Empty local data store
                self.roomLightsData = [RoomLightsBaseClass(json: responseJSON)] // Update local data store
                
                // Refresh the UI
                DispatchQueue.main.async {
                    UIView.performWithoutAnimation {
                        let loc = self.LightTableViewRooms.contentOffset
                        self.LightTableViewRooms.reloadData()
                        self.LightTableViewRooms.contentOffset = loc
                    }
                    SVProgressHUD.dismiss() // Stop spinner if visable
                }
            } else {
                self.refreshDataTimer.invalidate() // Stop the refresh data timer
            }
        })
        task.resume()
    }
}
