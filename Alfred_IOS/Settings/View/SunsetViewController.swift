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

class SunsetViewController: UIViewController {
    
    private let sunsetController = SunsetController()

    fileprivate var eveningData = [SettingsEvening]() {
        didSet {
            LightTableView?.reloadData()
            SVProgressHUD.dismiss() // Stop spinner
        }
    }
    
    @IBOutlet weak var LightTableView: UITableView!
    @IBOutlet weak var masterSwitch: UISwitch!
    @IBAction func masterSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            self.eveningData[0].masterOn = "true"
        } else {
            self.eveningData[0].masterOn = "false"
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.LightTableView.rowHeight = 80.0
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")

        // Add save button to navigation bar
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(saveSettingsAction(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        
        // Disable UI controls untill data is loaded
        navigationItem.rightBarButtonItem?.isEnabled = false
        self.offsetHRStepper.isEnabled = false
        self.offsetMINStepper.isEnabled = false
        self.masterSwitch.isEnabled = false
        
        // Get data
        sunsetController.getSunSetTime()
        sunsetController.getSunSetData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LightTableView?.delegate = self
        LightTableView?.dataSource = self
        sunsetController.delegate = self
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
                eveningData[0].lights?[slider.tag].brightness = Int(slider.value)
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
        
        if (eveningData[0].lights?[row!].onoff == "on") {
            eveningData[0].lights?[row!].onoff = "off"
            cell?.powerButton.backgroundColor = UIColor.clear
        } else {
            eveningData[0].lights?[row!].onoff = "on"
            
            // Setup the light bulb colour
            var color = UIColor.white
            switch eveningData[0].lights?[row!].colormode {
            case "ct"?: color = HueColorHelper.getColorFromScene((eveningData[0].lights?[row!].ct)!)
            case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((eveningData[0].lights?[row!].xy![0])!), y: Double((eveningData[0].lights?[row!].xy![1])!)), forModel: "LCT007")
            default: color = UIColor.white
            }
            cell?.powerButton.backgroundColor = color
        }
    }
    
    @objc func saveSettingsAction(sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false // Disable the save button
        sunsetController.saveSunSetData(data: eveningData)
    }
}

extension SunsetViewController: UITableViewDelegate {
}

extension SunsetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lightCell", for: indexPath) as! LightSettingsTableViewCell
        cell.configureWithItem(row: indexPath.row, item: eveningData[0].lights![indexPath.row])
        
        // Add UI actions
        cell.brightnessSlider?.addTarget(self, action: #selector(lightbrightnessValueChange(slider:event:)), for: UIControl.Event.valueChanged)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(powerButtonValueChange(_:)))
        cell.powerButton?.addGestureRecognizer(tapRecognizer)
        
        // ** TODO **
        //let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPowerButtonPress(_:)))
        //powerButton.addGestureRecognizer(longTapRecognizer)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (eveningData.count) > 0 {
            return (eveningData[0].lights?.count)!
        } else {
            return 0
        }
    }
}

extension SunsetViewController: SunsetControllerDelegate {
    func didFailDataUpdateWithError(displayMsg: Bool) {
        if displayMsg {
            SVProgressHUD.showError(withStatus: "Network/API error")
        }
    }

    func didRecieveSunSetTimeUpdate(data: String) {
        self.sunsetTimeLabel.text =  "Today's sunset: " + data
    }

    func didRecieveSunSetDataUpdate(data: [SettingsEvening]) {
        eveningData = data

        // Setup the offset and off timer settings
        if self.eveningData[0].masterOn == "true" {
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
    }
    
    func didSaveSunSetDataUpdate() {
        SVProgressHUD.showSuccess(withStatus: "Saved Settings")
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
}
