//
//  SunriseViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 26/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class SunriseViewController: UIViewController {
    
    private let sunriseController = SunriseController()
    
    fileprivate var morningData = [SettingsMorning]() {
        didSet {
            LightTableView?.reloadData()
            SVProgressHUD.dismiss() // Stop spinner
        }
    }
    
    @IBOutlet weak var LightTableView: UITableView!
    
    @IBOutlet weak var masterSwitch: UISwitch!
    @IBAction func masterSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            self.morningData[0].masterOn = "true"
        } else {
            self.morningData[0].masterOn = "false"
        }
    }
    @IBAction func turnOnHRStepper(_ sender: UIStepper) {
        turnOnHRLabel.text = Int(sender.value).description
        morningData[0].onHr = Int(sender.value)
    }
    @IBOutlet weak var turnOnHRStepper: UIStepper!
    @IBOutlet weak var turnOnHRLabel: UILabel!
    
    @IBAction func turnOnMINStepper(_ sender: UIStepper) {
        turnOnMINLabel.text = Int(sender.value).description
        morningData[0].onMin = Int(sender.value)
    }
    @IBOutlet weak var turnOnMINStepper: UIStepper!
    @IBOutlet weak var turnOnMINLabel: UILabel!
    
    @IBOutlet weak var sunRise: UILabel!
    //var colorPickerView: ColorViewController?
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.LightTableView.rowHeight = 80.0
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")
        
        // Add save button to navigation bar
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveSettingsAction(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        
        // Disable UI controls untill data is loaded
        self.turnOnHRStepper.isEnabled = false
        self.turnOnMINStepper.isEnabled = false
        self.masterSwitch.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // Get data
        sunriseController.getSunRiseTime()
        sunriseController.getSunRiseData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LightTableView?.delegate = self
        LightTableView?.dataSource = self
        sunriseController.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss() // Stop spinner
    }
    
    @objc func lightbrightnessValueChange(slider: UISlider, event: UIEvent) {
        slider.setValue(slider.value.rounded(.down), animated: true)
        
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .ended:
                morningData[0].lights?[slider.tag].brightness = Int(slider.value)
            default:
                break
            }
        }
    }
    
    @objc func powerButtonValueChange(_ sender: UITapGestureRecognizer!) {
        
        // Find out tapped cell
        let tapLocation = sender.location(in: self.LightTableView)
        let tapIndexPath = self.LightTableView?.indexPathForRow(at: tapLocation)
        let row = tapIndexPath?.row
        let cell = self.LightTableView?.cellForRow(at: tapIndexPath!) as? LightSettingsTableViewCell
        
        if (morningData[0].lights?[row!].onoff == "on") {
            morningData[0].lights?[row!].onoff = "off"
            cell?.powerButton.backgroundColor = UIColor.clear
        } else {
            morningData[0].lights?[row!].onoff = "on"
            
            // Setup the light bulb colour
            var color = UIColor.white
            switch morningData[0].lights?[row!].colormode {
            case "ct"?: color = HueColorHelper.getColorFromScene((morningData[0].lights?[row!].ct)!)
            case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((morningData[0].lights?[row!].xy![0])!), y: Double((morningData[0].lights?[row!].xy![1])!)), forModel: "LCT007")
            default: color = UIColor.white
            }
            cell?.powerButton.backgroundColor = color
        }
    }
    
    @objc func saveSettingsAction(sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false // Disable the save button
        sunriseController.saveSunriseData(data: morningData)
    }
}

extension SunriseViewController: UITableViewDelegate {
}

extension SunriseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lightCell", for: indexPath) as! LightSettingsTableViewCell
        cell.configureWithItem(row: indexPath.row, item: morningData[0].lights![indexPath.row])
        
        // Add UI actions
        cell.brightnessSlider?.addTarget(self, action: #selector(lightbrightnessValueChange(slider:event:)), for: .valueChanged)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(powerButtonValueChange(_:)))
        cell.powerButton?.addGestureRecognizer(tapRecognizer)
        
        // ** TODO **
        //let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPowerButtonPress(_:)))
        //powerButton.addGestureRecognizer(longTapRecognizer)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (morningData.count) > 0 {
            return (morningData[0].lights?.count)!
        } else {
            return 0
        }
    }
}

extension SunriseViewController: SunriseControllerDelegate {

    func didFailDataUpdateWithError(displayMsg: Bool) {
        if displayMsg {
            SVProgressHUD.showError(withStatus: "Network/API error")
        }
    }
    
    func didRecieveSunriseTimeUpdate(data: String) {
        self.sunRise.text =  "Today's sunrise: " + data
    }
    
    func didRecieveSunriseDataUpdate(data: [SettingsMorning]) {
        morningData = data
        
        // Setup the offset and off timer settings
        if self.morningData[0].masterOn == "true" {
            self.masterSwitch.setOn(true, animated: true)
        } else {
            self.masterSwitch.setOn(false, animated: true)
        }
        
        self.turnOnHRLabel.text = String(self.morningData[0].onHr!)
        self.turnOnHRStepper.value = Double(self.morningData[0].onHr!)
        self.turnOnMINLabel.text = String(self.morningData[0].onMin!)
        self.turnOnMINStepper.value = Double(self.morningData[0].onMin!)
        
        // Enable UI controls
        self.turnOnHRStepper.isEnabled = true
        self.turnOnMINStepper.isEnabled = true
        self.masterSwitch.isEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func didSaveSunriseDataUpdate() {
        SVProgressHUD.showSuccess(withStatus: "Saved Settings")
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
}




    /*
    
                    // Setup the offset and off timer settings
                    if self.morningData[0].master_on == "true" {
                        self.masterSwitch.setOn(true, animated: true)
                    } else {
                        self.masterSwitch.setOn(false, animated: true)
                    }
                    self.turnOnHRLabel.text = String(self.morningData[0].onHr!)
                    self.turnOnHRStepper.value = Double(self.morningData[0].onHr!)
                    self.turnOnMINLabel.text = String(self.morningData[0].onMin!)
                    self.turnOnMINStepper.value = Double(self.morningData[0].onMin!)
                    
                    // Enable UI controls
                    self.turnOnHRStepper.isEnabled = true
                    self.turnOnMINStepper.isEnabled = true
                    self.masterSwitch.isEnabled = true
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                        
                    // Refresh the table view
                    self.LightTableView.reloadData()
                    self.LightTableView.rowHeight = 80.0
                }
            }
        })
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (morningData.count) > 0 {
            return (morningData[0].lights!.count)
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "lightCell", for: indexPath) as! LightsTableViewCell
        let row = indexPath.row
        
        cell.tag = morningData[0].lights![row].lightID!
        cell.lightName.text = morningData[0].lights?[row].lightName
        
        // Work out light color
        if (morningData[0].lights?[row].onoff == "on") {
            
            // Setup the light bulb colour
            var color = UIColor.white
            switch morningData[0].lights?[row].colormode {
                case "ct"?: color = HueColorHelper.getColorFromScene((morningData[0].lights?[row].ct)!)
                case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((morningData[0].lights?[row].xy![0])!), y: Double((morningData[0].lights?[row].xy![1])!)), forModel: "LCT007")
                default: color = UIColor.white
            }
            cell.powerButton.backgroundColor = color
            
        } else {
            cell.powerButton.backgroundColor = UIColor.clear
        }
        
        // Set brightness slider
        cell.brightnessSlider.tag = row
        cell.brightnessSlider.value = Float((morningData[0].lights?[row].brightness)!)
        cell.brightnessSlider?.addTarget(self, action: #selector(brightnessValueChange(_:)), for: .touchUpInside)
        
        // Configure the power button
        cell.powerButton.tag = row
        cell.powerButton.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(powerButtonPress(_:)))
        cell.powerButton.addGestureRecognizer(tapRecognizer)
        let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPowerButtonPress(_:)))
        cell.powerButton.addGestureRecognizer(longTapRecognizer)
        
        return cell

    }
    
    @objc func brightnessValueChange(_ sender: UISlider!) {
        sender.setValue(sender.value.rounded(.down), animated: true)

        // Figure out which cell is being updated
        let cell = sender.superview?.superview as? LightsTableViewCell
        let row = sender.tag
        
        // Update local data store
        morningData[0].lights?[row].brightness = Int(sender.value)
        if sender.value == 0 {
            
            morningData[0].lights?[row].onoff = "off"
            cell?.powerButton.backgroundColor = UIColor.clear
            
        } else {
            
            morningData[0].lights?[row].onoff = "on"
            
            // Setup the light bulb colour
            var color = UIColor.white
            switch morningData[0].lights?[row].colormode {
                case "ct"?: color = HueColorHelper.getColorFromScene((morningData[0].lights?[row].ct)!)
                case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((morningData[0].lights?[row].xy![0])!), y: Double((morningData[0].lights?[row].xy![1])!)), forModel: "LCT007")
                default: color = UIColor.white
            }

            cell?.powerButton.backgroundColor = color
            
        }
    }
    
    @objc func powerButtonPress(_ sender: UITapGestureRecognizer!) {
        
        // Figure out which cell is being updated
        let touch = sender.location(in: LightTableView)
        let indexPath = LightTableView.indexPathForRow(at: touch)
        let row = indexPath?.row
        let cell = LightTableView.cellForRow(at: indexPath!) as! LightsTableViewCell

        if (morningData[0].lights?[row!].onoff == "on") {
            
            morningData[0].lights?[row!].onoff = "off"
            cell.powerButton.backgroundColor = UIColor.clear
            
        } else {
            
            morningData[0].lights?[row!].onoff = "on"
            
            // Setup the light bulb colour
            var color = UIColor.white
            switch morningData[0].lights?[row!].colormode {
                case "ct"?: color = HueColorHelper.getColorFromScene((morningData[0].lights?[row!].ct)!)
                case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((morningData[0].lights?[row!].xy![0])!), y: Double((morningData[0].lights?[row!].xy![1])!)), forModel: "LCT007")
                default: color = UIColor.white
            }

            cell.powerButton.backgroundColor = color

        }
    }
    
    @objc func longPowerButtonPress(_ sender: UITapGestureRecognizer!) {
    /*
        // Only do when finished long press
        if sender.state == .ended {
            
            // Figure out which cell is being updated
            let touch = sender.location(in: LightTableView)
            let indexPath = LightTableView.indexPathForRow(at: touch)
            let row = indexPath?.row
            let cell = LightTableView.cellForRow(at: indexPath!) as! LightsTableViewCell
            //cellID.sharedInstance.cell = cell

            // Store the color
            var color = UIColor.white
            switch morningData[0].lights?[row!].colormode {
                case "ct"?: color = HueColorHelper.getColorFromScene((morningData[0].lights?[row!].ct)!)
                case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((morningData[0].lights?[row!].xy![0])!), y: Double((morningData[0].lights?[row!].xy![1])!)), forModel: "LCT007")
                default: color = UIColor.white
            }
            
            // Open the color picker
            performSegue(withIdentifier: "sunriseShowColor", sender: color)
            
        }
 */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let secondViewController = segue.destination as! ColorViewController
        secondViewController.delegate = self
        secondViewController.colorID = sender as? UIColor
        
    }
    
    func backFromColorPicker(_ newColor: UIColor?, ct: Int?, scene: Bool?) {
/*
        // Update the local data store
        let cell = cellID.sharedInstance.cell
        let row = cell?.powerButton.tag
        
        if scene! {
            // Color selected from scene list
            morningData[0].lights![row!].ct = ct
            morningData[0].lights![row!].colormode = "ct"
            cell?.powerButton.backgroundColor = HueColorHelper.getColorFromScene(ct!)
        } else {
            // Color seclected from color pallet
            let xy = HueColorHelper.calculateXY(newColor!, forModel: "LST007")
            morningData[0].lights![row!].xy = [Float(xy.x), Float(xy.y)]
            morningData[0].lights![row!].colormode = "xy"
            cell?.powerButton.backgroundColor = newColor
        }
*/
    }
    
    @objc func saveSettingsAction(sender: UIBarButtonItem) {
        
        // Disable the save button
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // Call API
        let APIbody: Data = try! JSONSerialization.data(withJSONObject: self.morningData[0].dictionaryRepresentation(), options: [])
        let request = putAPIHeaderData(url: "settings/savemorning", body: APIbody, useScheduler: true)
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
*/
