//
//  SunsetViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 14/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class SunsetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, colorPickerDelegate, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!) )
    }
    
    var eveningData = [Evening]()
    
    @IBOutlet weak var LightTableView: UITableView!
    
    @IBOutlet weak var masterSwitch: UISwitch!
    @IBAction func masterSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            self.eveningData[0].master_on = "true"
        } else {
            self.eveningData[0].master_on = "false"
        }
    }
    @IBOutlet weak var offsetHRLabel: UILabel!
    @IBOutlet weak var offsetHRStepper: UIStepper!
    @IBAction func offsetHRStepper(_ sender: UIStepper) {
        offsetHRLabel.text = Int(sender.value).description
        eveningData[0].offsetHr = Int(sender.value)
    }
    
    @IBOutlet weak var offsetMINLabel: UILabel!
    @IBOutlet weak var offsetMINStepper: UIStepper!
    @IBAction func offsetMINStepper(_ sender: UIStepper) {
        offsetMINLabel.text = Int(sender.value).description
        eveningData[0].offsetMin = Int(sender.value)
    }
    
    @IBOutlet weak var sunsetTimeLabel: UILabel!

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")
        
        // Add save button to navigation bar
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveSettingsAction(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        
        // Disable UI controls untill data is loaded
        navigationItem.rightBarButtonItem?.isEnabled = false
        self.offsetHRStepper.isEnabled = false
        self.offsetMINStepper.isEnabled = false
        self.masterSwitch.isEnabled = false

        // Get sunset configuration info from Alfred
        self.getData()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getData() {

        // Get sunset time
        var request = getAPIHeaderData(url: "weather/sunset", useScheduler: false)
        var session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        var task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let json = JSON(data: data!)
                let sunSet = json["data"].string! // Save json to custom classes
                // Update the sunset time label
                DispatchQueue.main.async {
                    self.sunsetTimeLabel.text =  "Today's sunset: " + sunSet
                }
            }
        })
        task.resume()

        // Get settings
        request = getAPIHeaderData(url: "settings/view", useScheduler: true)
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                
                SVProgressHUD.dismiss() // Dismiss loading HUD

                let json = JSON(data: data!)
                // Save json to custom classes
                let jsonData = json["data"]["on"]["evening"]
                self.eveningData = [Evening(json: jsonData)]
                
                // Setup the offset and off timer settings
                if self.eveningData[0].master_on == "true" {
                    self.masterSwitch.setOn(true, animated: true)
                } else {
                    self.masterSwitch.setOn(false, animated: true)
                }
                self.offsetHRLabel.text = String(self.eveningData[0].offsetHr!)
                self.offsetHRStepper.value = Double(self.eveningData[0].offsetHr!)
                self.offsetMINLabel.text = String(self.eveningData[0].offsetMin!)
                self.offsetMINStepper.value = Double(self.eveningData[0].offsetMin!)
                
                // Enable UI controls
                self.offsetHRStepper.isEnabled = true
                self.offsetMINStepper.isEnabled = true
                self.masterSwitch.isEnabled = true
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                
                // Refresh the table view
                DispatchQueue.main.async {
                    self.LightTableView.reloadData()
                    self.LightTableView.rowHeight = 80.0
                }
            }
        })
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (eveningData.count) > 0 {
            return (eveningData[0].lights?.count)!
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "lightCell", for: indexPath) as! LightsTableViewCell
        let row = indexPath.row
        
        cell.tag = (eveningData[0].lights?[row].lightID)!
        
        cell.lightName.text = eveningData[0].lights?[row].lightName
        
        // Work out light color
        if (eveningData[0].lights?[row].onoff == "on") {
            
            // Setup the light bulb colour
            var color = UIColor.white
            switch eveningData[0].lights?[row].colormode {
                case "ct"?: color = HueColorHelper.getColorFromScene((eveningData[0].lights?[row].ct)!)
                case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((eveningData[0].lights?[row].xy![0])!), y: Double((eveningData[0].lights?[row].xy![1])!)), forModel: "LCT007")
                default: color = UIColor.white
            }
            cell.powerButton.backgroundColor = color
            
        } else {
            cell.powerButton.backgroundColor = UIColor.clear
        }
        
        cell.brightnessSlider.value = Float((eveningData[0].lights?[row].brightness)!)
        cell.brightnessSlider.tag = row
        cell.brightnessSlider?.addTarget(self, action: #selector(brightnessValueChange(_:)), for: .touchUpInside)
        
        // Configure the power button
        cell.powerButton.tag = row
        cell.powerButton.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(powerButtonValueChange(_:)))
        cell.powerButton.addGestureRecognizer(tapRecognizer)
        
        if eveningData[0].lights?[row].type == "color" {
            let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPowerButtonPress(_:)))
            cell.powerButton.addGestureRecognizer(longTapRecognizer)
        }
        
        return cell
        
    }
    
    @objc func brightnessValueChange(_ sender: UISlider!) {
        sender.setValue(sender.value.rounded(.down), animated: true)

        // Figure out which cell is being updated
        let cell = sender.superview?.superview as? LightsTableViewCell
        let row = sender.tag
        
        // Update local data store
        eveningData[0].lights?[row].brightness = Int(sender.value)
        if sender.value == 0 {
            
            eveningData[0].lights?[row].onoff = "off"
            cell?.powerButton.backgroundColor = UIColor.clear
            
        } else {
            
            eveningData[0].lights?[row].onoff = "on"
            
            // Setup the light bulb colour
            var color = UIColor.white
            switch eveningData[0].lights?[row].colormode {
                case "ct"?: color = HueColorHelper.getColorFromScene((eveningData[0].lights?[row].ct)!)
                case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((eveningData[0].lights?[row].xy![0])!), y: Double((eveningData[0].lights?[row].xy![1])!)), forModel: "LCT007")
                default: color = UIColor.white
            }
            cell?.powerButton.backgroundColor = color
        }
    }
    
    @objc func powerButtonValueChange(_ sender: UITapGestureRecognizer!) {
        
        // Figure out which cell is being updated
        let touch = sender.location(in: LightTableView)
        let indexPath = LightTableView.indexPathForRow(at: touch)
        let row = indexPath?.row
        let cell = LightTableView.cellForRow(at: indexPath!) as! LightsTableViewCell

        if (eveningData[0].lights?[row!].onoff == "on") {
            
            eveningData[0].lights?[row!].onoff = "off"
            cell.powerButton.backgroundColor = UIColor.clear
            
        } else {
            
            eveningData[0].lights?[row!].onoff = "on"
            
            // Setup the light bulb colour
            var color = UIColor.white
            switch eveningData[0].lights?[row!].colormode {
                case "ct"?: color = HueColorHelper.getColorFromScene((eveningData[0].lights?[row!].ct)!)
                case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((eveningData[0].lights?[row!].xy![0])!), y: Double((eveningData[0].lights?[row!].xy![1])!)), forModel: "LCT007")
                default: color = UIColor.white
            }
            cell.powerButton.backgroundColor = color
            
        }
    }
    
    @objc func longPowerButtonPress(_ sender: UITapGestureRecognizer!) {
        
        // Only do when finished long press
        if sender.state == .ended {
            
            // Figure out which cell is being updated
            let touch = sender.location(in: LightTableView)
            let indexPath = LightTableView.indexPathForRow(at: touch)
            let row = indexPath?.row
            let cell = LightTableView.cellForRow(at: indexPath!) as! LightsTableViewCell
            cellID.sharedInstance.cell = cell
                        
            // Setup the light bulb colour
            var color = UIColor.white
            switch eveningData[0].lights?[row!].colormode {
                case "ct"?: color = HueColorHelper.getColorFromScene((eveningData[0].lights?[row!].ct)!)
                case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((eveningData[0].lights?[row!].xy![0])!), y: Double((eveningData[0].lights?[row!].xy![1])!)), forModel: "LCT007")
                default: color = UIColor.white
            }

            performSegue(withIdentifier: "sunsetShowColor", sender: color) // Open the color picker
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondViewController = segue.destination as! ColorViewController
        secondViewController.delegate = self
        secondViewController.colorID = sender as? UIColor
    }
    
    func backFromColorPicker(_ newColor: UIColor?, ct: Int?, scene: Bool?) {

        // Update the local data store
        let cell = cellID.sharedInstance.cell
        let row = cell?.powerButton.tag
        
        if scene! {
            // Color selected from scene list
            eveningData[0].lights![row!].ct = ct
            eveningData[0].lights![row!].colormode = "ct"
            cell?.powerButton.backgroundColor = HueColorHelper.getColorFromScene(ct!)
        } else {
            // Color seclected from color pallet
            let xy = HueColorHelper.calculateXY(newColor!, forModel: "LST007")
            eveningData[0].lights![row!].xy = [Float(xy.x), Float(xy.y)]
            eveningData[0].lights![row!].colormode = "xy"
            cell?.powerButton.backgroundColor = newColor
        }

    }
    
    @objc func saveSettingsAction(sender: UIBarButtonItem) {
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false // Disable the save button

        // Call Alfred scheduler to update the settings
        let body = try! JSONSerialization.data(withJSONObject: self.eveningData[0].dictionaryRepresentation(), options: [])
        let request = putAPIHeaderData(url: "settings/saveevening", body: body, useScheduler: true)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if !checkAPIData(apiData: data, response: response, error: error) {
                // Show error
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showError(withStatus: "Unable to update the settings")
                    self.navigationItem.rightBarButtonItem?.isEnabled = true // Re enable the save button
                }
            } else {
                // Show sucess msg
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showSuccess(withStatus: "Saved")
                    self.navigationItem.rightBarButtonItem?.isEnabled = true // Re enable the save button
                }
            }
        })
        task.resume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss() // Stop spinner
    }
}
