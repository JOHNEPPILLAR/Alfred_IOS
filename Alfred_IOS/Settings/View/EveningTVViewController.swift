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

class EveningTVViewController: UIViewController {
    
    private let eveningTVController = EveningTVController()
    
    fileprivate var eveningTVData = [SettingsEveningtv]() {
        didSet {
            LightTableView?.reloadData()
            SVProgressHUD.dismiss() // Stop spinner
        }
    }
    
    @IBOutlet weak var LightTableView: UITableView!
    @IBOutlet weak var masterSwitch: UISwitch!
    @IBAction func masterSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            self.eveningTVData[0].masterOn = "true"
        } else {
            self.eveningTVData[0].masterOn = "false"
        }
    }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.LightTableView.rowHeight = 80.0
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")
        
        // Add save button to navigation bar
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(saveSettingsAction(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        
        // Disable UI controls untill data is loaded
        self.turnOnHRStepper.isEnabled = false
        self.turnOnMINStepper.isEnabled = false
        self.masterSwitch.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // Get data
        eveningTVController.getData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LightTableView?.delegate = self
        LightTableView?.dataSource = self
        eveningTVController.delegate = self
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
                eveningTVData[0].lights?[slider.tag].brightness = Int(slider.value)
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
        
        if (eveningTVData[0].lights?[row!].onoff == "on") {
            eveningTVData[0].lights?[row!].onoff = "off"
            cell?.powerButton.backgroundColor = UIColor.clear
        } else {
            eveningTVData[0].lights?[row!].onoff = "on"
            
            // Setup the light bulb colour
            var color = UIColor.white
            switch eveningTVData[0].lights?[row!].colormode {
            case "ct"?: color = HueColorHelper.getColorFromScene((eveningTVData[0].lights?[row!].ct)!)
            case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((eveningTVData[0].lights?[row!].xy![0])!), y: Double((eveningTVData[0].lights?[row!].xy![1])!)), forModel: "LCT007")
            default: color = UIColor.white
            }
            cell?.powerButton.backgroundColor = color
        }
    }
    
    @objc func saveSettingsAction(sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false // Disable the save button
        eveningTVController.saveEveningTVData(data: eveningTVData)
    }
}

extension EveningTVViewController: UITableViewDelegate {
}

extension EveningTVViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lightCell", for: indexPath) as! LightSettingsTableViewCell
        cell.configureWithItem(row: indexPath.row, item: eveningTVData[0].lights![indexPath.row])
        
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
        if (eveningTVData.count) > 0 {
            return (eveningTVData[0].lights?.count)!
        } else {
            return 0
        }
    }
}

extension EveningTVViewController: EveningTVControllerDelegate {
    
    func didFailDataUpdateWithError(displayMsg: Bool) {
        if displayMsg {
            SVProgressHUD.showError(withStatus: "Network/API error")
        }
    }
    
    func didRecieveEveningTVDataUpdate(data: [SettingsEveningtv]) {
        eveningTVData = data
        
        // Setup the offset and off timer settings
        if self.eveningTVData[0].masterOn == "true" {
            self.masterSwitch.setOn(true, animated: true)
        } else {
            self.masterSwitch.setOn(false, animated: true)
        }
        self.turnOnHRLabel.text = String(self.eveningTVData[0].onHr!)
        self.turnOnHRStepper.value = Double(self.eveningTVData[0].onHr!)
        
        self.turnOnMINLabel.text = String(self.eveningTVData[0].onMin!)
        self.turnOnMINStepper.value = Double(self.eveningTVData[0].onMin!)
        
        // Enable UI controls
        self.turnOnHRStepper.isEnabled = true
        self.turnOnMINStepper.isEnabled = true
        self.masterSwitch.isEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func didSaveEveningTVDataUpdate() {
        SVProgressHUD.showSuccess(withStatus: "Saved Settings")
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
}
