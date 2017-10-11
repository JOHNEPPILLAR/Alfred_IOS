//
//  EveningTVViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 27/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import MTCircularSlider

class EveningTVViewController: UIViewController, UICollectionViewDataSource, colorPickerDelegate, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!) )
    }
    
    var eveningTVData = [EveningTV]()
    
    @IBOutlet weak var LightCollectionView: UICollectionView!
    
    @IBOutlet weak var turnOnHRLabel: UILabel!
    @IBOutlet weak var turnOnHRStepper: UIStepper!
    @IBAction func turnOnHRStepper(_ sender: UIStepper) {
        turnOnHRLabel.text = Int(sender.value).description
        eveningTVData[0].onHr = Int(sender.value)
    }
    
    @IBOutlet weak var turnOnMINStepper: UIStepper!
    @IBOutlet weak var turnOnMINLabel: UILabel!
    @IBAction func turnOnMINStepper(_ sender: UIStepper) {
        turnOnMINLabel.text = Int(sender.value).description
        eveningTVData[0].onMin = Int(sender.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add save button to navigation bar
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveSettingsAction(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        
        // Disable UI controls untill data is loaded
        navigationItem.rightBarButtonItem?.isEnabled = false
        self.turnOnHRStepper.isEnabled = false
        self.turnOnMINStepper.isEnabled = false
        
        // Get evening TV lights configuration info from Alfred
        self.getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getData() {

        // Get settings
        let request = getAPIHeaderData(url: "settings/view", useScheduler: true)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                
                // Save json to custom classes
                let json = JSON(data: data!)
                let jsonData = json["data"]["eveningtv"]
                self.eveningTVData = [EveningTV(json: jsonData)]
                DispatchQueue.main.async {
                    // Setup the offset and off timer settings
                    self.turnOnHRLabel.text = String(self.eveningTVData[0].onHr!)
                    self.turnOnHRStepper.value = Double(self.eveningTVData[0].onHr!)
                        
                    self.turnOnMINLabel.text = String(self.eveningTVData[0].onMin!)
                    self.turnOnMINStepper.value = Double(self.eveningTVData[0].onMin!)
                        
                    // Enable UI controls
                    self.turnOnHRStepper.isEnabled = true
                    self.turnOnMINStepper.isEnabled = true
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                        
                    // Refresh the table view
                    self.LightCollectionView.reloadData()
                }
            }
        })
        task.resume()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (eveningTVData.count) > 0 {
            return (eveningTVData[0].lights?.count)!
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lightCell", for: indexPath) as! LightsCollectionViewCell
        let row = indexPath.row
        
        cell.tag = (eveningTVData[0].lights?[row].lightID)!
        
        cell.lightName.setTitle(eveningTVData[0].lights?[row].lightName, for: .normal)
        
        // Work out light group color
        if (eveningTVData[0].lights?[row].onoff == "on") {

            // Setup the light bulb colour
            var color = UIColor.white
            switch eveningTVData[0].lights?[row].colormode {
                case "ct"?: color = HueColorHelper.getColorFromScene((eveningTVData[0].lights?[row].ct)!)
                case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((eveningTVData[0].lights?[row].xy![0])!), y: Double((eveningTVData[0].lights?[row].xy![1])!)), forModel: "LCT007")
                default: color = UIColor.white
            }
            cell.powerButton.backgroundColor = color
            
        } else {
            cell.powerButton.backgroundColor = UIColor.clear
        }
        
        cell.brightnessSlider.value = Float((eveningTVData[0].lights?[row].brightness)!)
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
        
        // Update local data store
        eveningTVData[0].lights?[row].brightness = Int(sender.value)
        if sender.value == 0 {
            
            eveningTVData[0].lights?[row].onoff = "off"
            cell?.powerButton.backgroundColor = UIColor.clear
            
        } else {
            
            eveningTVData[0].lights?[row].onoff = "on"
            
            // Setup the light bulb colour
            var color = UIColor.white
            switch eveningTVData[0].lights?[row].colormode {
            case "ct"?: color = HueColorHelper.getColorFromScene((eveningTVData[0].lights?[row].ct)!)
            case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((eveningTVData[0].lights?[row].xy![0])!), y: Double((eveningTVData[0].lights?[row].xy![1])!)), forModel: "LCT007")
            default: color = UIColor.white
            }
            cell?.powerButton.backgroundColor = color

        }
    }
    
    @objc func powerButtonValueChange(_ sender: UITapGestureRecognizer!) {
        
        // Figure out which cell is being updated
        let point : CGPoint = sender.view!.convert(CGPoint.zero, to:LightCollectionView)
        let indexPath = LightCollectionView!.indexPathForItem(at: point)
        let cell = LightCollectionView!.cellForItem(at: indexPath!) as! LightsCollectionViewCell
        let row = indexPath?.row
        
        if (eveningTVData[0].lights?[row!].onoff == "on") {
            
            eveningTVData[0].lights?[row!].onoff = "off"
            cell.powerButton.backgroundColor = UIColor.clear
            
        } else {
            
            eveningTVData[0].lights?[row!].onoff = "on"
            
            // Setup the light bulb colour
            var color = UIColor.white
            switch eveningTVData[0].lights?[row!].colormode {
                case "ct"?: color = HueColorHelper.getColorFromScene((eveningTVData[0].lights?[row!].ct)!)
                case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((eveningTVData[0].lights?[row!].xy![0])!), y: Double((eveningTVData[0].lights?[row!].xy![1])!)), forModel: "LCT007")
                default: color = UIColor.white
            }
            cell.powerButton.backgroundColor = color

        }
    }
    
    @objc func longPowerButtonPress(_ sender: UITapGestureRecognizer!) {
        
        // Only do when finished long press
        if sender.state == .ended {
            
            // Figure out which cell is being updated
            let point : CGPoint = sender.view!.convert(CGPoint.zero, to:LightCollectionView)
            let indexPath = LightCollectionView!.indexPathForItem(at: point)
            let row = indexPath?.row
            let cell = LightCollectionView!.cellForItem(at: indexPath!) as! LightsCollectionViewCell
            cellID.sharedInstance.cell = cell
            
            // Store the color
            var color = UIColor.white
            switch eveningTVData[0].lights?[row!].colormode {
                case "ct"?: color = HueColorHelper.getColorFromScene((eveningTVData[0].lights?[row!].ct)!)
                case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((eveningTVData[0].lights?[row!].xy![0])!), y: Double((eveningTVData[0].lights?[row!].xy![1])!)), forModel: "LCT007")
                default: color = UIColor.white
            }

            // Open the color picker
            performSegue(withIdentifier: "eveningTVShowColor", sender: color)
            
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
            eveningTVData[0].lights![row!].ct = ct
            eveningTVData[0].lights![row!].colormode = "ct"
            cell?.powerButton.backgroundColor = HueColorHelper.getColorFromScene(ct!)
        } else {
            // Color seclected from color pallet
            let xy = HueColorHelper.calculateXY(newColor!, forModel: "LST007")
            eveningTVData[0].lights![row!].xy = [Float(xy.x), Float(xy.y)]
            eveningTVData[0].lights![row!].colormode = "xy"
            cell?.powerButton.backgroundColor = newColor
        }
    }
    
    @objc func saveSettingsAction(sender: UIBarButtonItem) {
        
        // Disable the save button
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // Call API
        let APIbody: Data = try! JSONSerialization.data(withJSONObject: self.eveningTVData[0].dictionaryRepresentation(), options: [])
        let request = putAPIHeaderData(url: "settings/saveeveningtv", body: APIbody, useScheduler: true)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showSuccess(withStatus: "Saved")
                }
            } else {
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showError(withStatus: "Unable to save settings")
                }
            }
            
            // Re enable the save button
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        })
        task.resume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop spinner
        SVProgressHUD.dismiss()
    }

}
