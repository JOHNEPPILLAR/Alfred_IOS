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
import MTCircularSlider

class RoomLightsViewController: UIViewController, UICollectionViewDataSource, colorPickerDelegate, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!) )
    }

    var roomLightsData = [RoomLightsBaseClass]()
    var getDataTimer: Timer!
    
    @IBOutlet weak var LightCollectionViewRooms: UICollectionView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")

        self.getData() // Get room lights configuration info from Alfred

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss() // Stop spinner
    }
    
    func getData() {
        let request = getAPIHeaderData(url: "lights/listlightgroups", useScheduler: false)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = JSON(data: data!)
                self.roomLightsData = [RoomLightsBaseClass(json: responseJSON)]
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss() // Dismiss the loading HUD
                    self.LightCollectionViewRooms.reloadData() // Refresh the colection view
                }
            }
        })
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (roomLightsData.count) > 0 {
            return (roomLightsData[0].data!.count)
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lightCell", for: indexPath) as! LightsCollectionViewCell
        let row = indexPath.row
        cell.tag = Int((roomLightsData[0].data![row].id)!)!
        cell.lightName.setTitle(roomLightsData[0].data![row].name, for: .normal)
        
        // Work out light group color
        if (roomLightsData[0].data![row].state?.anyOn)! {
            
            // Setup the light bulb colour
            var color = UIColor.white
            switch roomLightsData[0].data![row].action?.colormode {
            case "ct"?: color = HueColorHelper.getColorFromScene((roomLightsData[0].data![row].action?.ct)!)
            case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((roomLightsData[0].data![row].action?.xy![0])!), y: Double((roomLightsData[0].data![row].action?.xy![1])!)), forModel: "LCT007")
                default: color = UIColor.white
            }
            cell.powerButton.backgroundColor = color
            
        }
        
        cell.brightnessSlider.isHidden = true
        if (roomLightsData[0].data![row].state?.anyOn)! {
            cell.brightnessSlider.isHidden = false
        }
        cell.brightnessSlider.value = Float((roomLightsData[0].data![row].action?.bri)!)
        cell.brightnessSlider.tag = row
        cell.brightnessSlider?.addTarget(self, action: #selector(brightnessValueChange(_:)), for: .touchUpInside)
        
        // Configure the power button
        cell.powerButton.tag = row
        cell.powerButton.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(powerButtonValueChange(_:)))
        cell.powerButton.addGestureRecognizer(tapRecognizer)
        let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPowerButtonPress(_:)))
        cell.powerButton.addGestureRecognizer(longTapRecognizer)

        return cell
    }
    
    @objc func brightnessValueChange(_ sender: MTCircularSlider!) {
        
        // Figure out which cell is being updated
        let cell = sender.superview?.superview as? LightsCollectionViewCell
        let row = sender.tag
        var lightsOn: String
        
        // Update local data store
        roomLightsData[0].data![row].action?.bri = Int(sender.value)
        lightsOn = "off"
        if (roomLightsData[0].data![row].state?.anyOn)! { lightsOn = "on" }
        
        // Call Alfred to update the light group
        let body: [String: Any] = ["light_number": cell!.tag, "light_status": lightsOn, "brightness": self.roomLightsData[0].data![row].action!.bri!]
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
            }
        })
        task.resume()
    }
    
    @objc func powerButtonValueChange(_ sender: UITapGestureRecognizer!) {
        
        // Figure out which cell is being updated
        let point : CGPoint = sender.view!.convert(CGPoint.zero, to:LightCollectionViewRooms)
        let indexPath = LightCollectionViewRooms!.indexPathForItem(at: point)
        let cell = LightCollectionViewRooms!.cellForItem(at: indexPath!) as! LightsCollectionViewCell
        let row = indexPath?.row
        var lightsOn: String
        
        if (roomLightsData[0].data![row!].state?.anyOn)! {
            
            roomLightsData[0].data![row!].state?.anyOn = false
            cell.powerButton.backgroundColor = UIColor.clear
            cell.brightnessSlider.isHidden = true
            lightsOn = "off"
            
        } else {
            
            roomLightsData[0].data![row!].state?.anyOn = true
            cell.brightnessSlider.isHidden = false
            lightsOn = "on"

            // Setup the light bulb colour
            var color = UIColor.white
            switch roomLightsData[0].data![row!].action?.colormode {
            case "ct"?: color = HueColorHelper.getColorFromScene((roomLightsData[0].data![row!].action?.ct)!)
            case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((roomLightsData[0].data![row!].action?.xy![0])!), y: Double((roomLightsData[0].data![row!].action?.xy![1])!)), forModel: "LCT007")
                default: color = UIColor.white
            }
            cell.powerButton.backgroundColor = color
            
            //if roomLightsData[0].data![row!].action?.bri == 0 {
            //    roomLightsData[0].data![row!].action?.bri = 100
            //    cell.brightnessSlider.value = 100
            //}
            
        }
        
        // Call Alfred to update the light group
        let body: [String: Any] = ["light_number": cell.tag, "light_status": lightsOn, "brightness": self.roomLightsData[0].data![row!].action!.bri!]
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
            }
        })
        task.resume()
    }
    
    @objc func longPowerButtonPress(_ sender: UITapGestureRecognizer!) {
        
        // Only do when finished long press
        if sender.state == .ended {
            
            // Figure out which cell is being updated
            let point : CGPoint = sender.view!.convert(CGPoint.zero, to:LightCollectionViewRooms)
            let indexPath = LightCollectionViewRooms!.indexPathForItem(at: point)
            let row = indexPath?.row
            let cell = LightCollectionViewRooms!.cellForItem(at: indexPath!) as! LightsCollectionViewCell
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
        
        // Setup the local vars and the post to api data
        var lightsOn = "off"
        if (roomLightsData[0].data![row].state?.anyOn)! {
            lightsOn = "on"
        }
        var body: [String: Any] = ["light_number": cell?.tag as Any, "light_status": lightsOn, "brightness": self.roomLightsData[0].data![row].action!.bri!]

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
            }
        })
        task.resume()
    }
    
    @IBAction func turnOffAllLights(recognizer:UIPanGestureRecognizer) {
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
                // Update local data & UI and turn off all light groups
                for var i in (0..<self.roomLightsData.count){
                    self.roomLightsData[0].data![i].state?.anyOn = false
                    
                    let indexPath = IndexPath(row: i, section: 0)
                    let cell = self.LightCollectionViewRooms!.cellForItem(at: indexPath) as! LightsCollectionViewCell
                    DispatchQueue.main.async {
                        cell.powerButton.backgroundColor = UIColor.clear
                    }
                    i += 1
                }
                // Show sucess msg
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showSuccess(withStatus: "Turned off all lights")
                }
            }
        })
        task.resume()
    }
}
