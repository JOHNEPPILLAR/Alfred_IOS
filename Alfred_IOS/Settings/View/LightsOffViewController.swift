//
//  LightsOffViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 15/10/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class LightsOffViewController: UIViewController, URLSessionDelegate {
    
    private let lightsOffController = LightsOffController()
    
    fileprivate var lightsOffData = [SettingsOff]() {
        didSet {
            SVProgressHUD.dismiss() // Stop spinner
        }
    }
    
    @IBOutlet weak var MorningOnOff: UISwitch!
    @IBAction func MorningOnOffAction(_ sender: UISwitch) {
        if sender.isOn {
            self.lightsOffData[0].morning!.masterOn = "true"
        } else {
            self.lightsOffData[0].morning!.masterOn = "false"
        }
    }
    @IBOutlet weak var MorningHrStep: UIStepper!
    @IBAction func MorningHrStepper(_ sender: UIStepper) {
        MorningHr.text = Int(sender.value).description
        lightsOffData[0].morning!.offHr = Int(sender.value)
    }
    @IBOutlet weak var MorningHr: UILabel!
    @IBOutlet weak var MorningMinStep: UIStepper!
    @IBAction func MorningMinStepper(_ sender: UIStepper) {
        MorningMin.text = Int(sender.value).description
        lightsOffData[0].morning!.offMin = Int(sender.value)
    }
    @IBOutlet weak var MorningMin: UILabel!
    @IBOutlet weak var EveningOnOff: UISwitch!
    @IBAction func EveningOnOffAction(_ sender: UISwitch) {
        if sender.isOn {
            self.lightsOffData[0].evening!.masterOn = "true"
        } else {
            self.lightsOffData[0].evening!.masterOn = "false"
        }
    }
    @IBOutlet weak var EveningHrStep: UIStepper!
    @IBAction func EveningHrStepper(_ sender: UIStepper) {
        EveningHr.text = Int(sender.value).description
        lightsOffData[0].evening!.offHr = Int(sender.value)
    }
    @IBOutlet weak var EveningHr: UILabel!
    @IBOutlet weak var EveningMinStep: UIStepper!
    @IBAction func EveningMinStepper(_ sender: UIStepper) {
        EveningMin.text = Int(sender.value).description
        lightsOffData[0].evening!.offMin = Int(sender.value)
    }
    @IBOutlet weak var EveningMin: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")
        
        // Add save button to navigation bar
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveSettingsAction(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        
        // Disable UI controls untill data is loaded
        navigationItem.rightBarButtonItem?.isEnabled = false
        self.MorningOnOff.isEnabled = false
        self.MorningHrStep.isEnabled = false
        self.MorningMinStep.isEnabled = false
        self.EveningHrStep.isEnabled = false
        self.EveningMinStep.isEnabled = false
       
        // Get data
        lightsOffController.getData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lightsOffController.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss() // Stop spinner
    }

    @objc func saveSettingsAction(sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false // Disable the save button
        lightsOffController.saveLightsOffData(data: lightsOffData)
    }
}

extension LightsOffViewController: LightsOffControllerDelegate {
  
    func didFailDataUpdateWithError(displayMsg: Bool) {
        if displayMsg {
            SVProgressHUD.showError(withStatus: "Network/API error")
        }
    }
    
    func didRecieveLightsOffDataUpdate(data: [SettingsOff]) {
        lightsOffData = data
        
        // Setup the offset and off timer settings
        if self.lightsOffData[0].morning?.masterOn == "true" {
            self.MorningOnOff.setOn(true, animated: true)
        } else {
            self.MorningOnOff.setOn(false, animated: true)
        }
        self.MorningHrStep.value = Double((self.lightsOffData[0].morning!.offHr)!)
        self.MorningHr.text = "\(self.lightsOffData[0].morning!.offHr!)"
        self.MorningMinStep.value = Double((self.lightsOffData[0].morning!.offMin)!)
        self.MorningMin.text = "\(self.lightsOffData[0].morning!.offMin!)"
        
        self.EveningHrStep.value = Double((self.lightsOffData[0].evening!.offHr)!)
        self.EveningHr.text = "\(self.lightsOffData[0].evening!.offHr!)"
        self.EveningMinStep.value = Double((self.lightsOffData[0].evening!.offMin)!)
        self.EveningMin.text = "\(self.lightsOffData[0].evening!.offMin!)"
        
        // Enable UI controls
        self.MorningOnOff.isEnabled = true
        self.MorningHrStep.isEnabled = true
        self.MorningMinStep.isEnabled = true
        self.EveningHrStep.isEnabled = true
        self.EveningMinStep.isEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func didSaveLightsOffDataUpdate() {
        SVProgressHUD.showSuccess(withStatus: "Saved Settings")
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
}
