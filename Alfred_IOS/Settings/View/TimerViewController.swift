//
//  TimerViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 15/09/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class ViewTimerController: UIViewController {

    var timerID:Int = 0

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var aiEnabled: UISwitch!
    @IBOutlet weak var active: UISwitch!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    private let timerController = TimerController()
    
    fileprivate var TimersDataArray = [TimersData]() {
        didSet {
            name.text = TimersDataArray[0].rows![timerID].name
            if (TimersDataArray[0].rows![timerID].aiOverride!) { aiEnabled.isOn = true } else { aiEnabled.isOn = false }
            if (TimersDataArray[0].rows![timerID].active!) { active.isOn = true } else { active.isOn = false }

            let hour =  "\(TimersDataArray[0].rows![timerID].hour ?? 0)"
            let minute =  "\(TimersDataArray[0].rows![timerID].minute ?? 0)"
            
            let strDate = hour + ":" + minute
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let date = dateFormatter.date(from: strDate)
            self.timePicker.datePickerMode = .time
            self.timePicker.setDate(date!, animated: false)
            
            // Enable edit ui untill data is loaded
            name.isEnabled = true
            active.isEnabled = true
            aiEnabled.isEnabled = true
            timePicker.isEnabled = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true // Enable the save button
            
            SVProgressHUD.dismiss() // Stop spinner
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerController.delegate = self
        timePicker.setValue(UIColor.white, forKey: "textColor")
        
        // Disable edit ui untill data is loaded
        name.isEnabled = false
        active.isEnabled = false
        aiEnabled.isEnabled = false
        timePicker.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false // Disable the save button
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")
        
        // Add save button to navigation bar
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(saveSettingsAction(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.rightBarButtonItem!.isEnabled = false

        timerController.getTimerData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss() // Stop spinner
    }

    @objc func saveSettingsAction(sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false // Disable the save button
        
        // Call save function
        let date = timePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let body = ["id": TimersDataArray[0].rows![timerID].id!, "name": name.text!, "hour": hour, "minute": minute, "ai_override": aiEnabled.isOn, "active": active.isOn ] as [String : Any]
        timerController.saveTimerData(body: body)
    }
}

extension ViewTimerController: TimerControllerDelegate {
    func didFailDataUpdateWithError(displayMsg: Bool) {
        if displayMsg {
            SVProgressHUD.showError(withStatus: "Unable to save data")
            navigationItem.rightBarButtonItem!.isEnabled = true
        } else {
            SVProgressHUD.showError(withStatus: "Network/API error")
        }
    }
    
    func timerDidRecieveDataUpdate(data: [TimersData]) {
        TimersDataArray = data
    }

    func timerSaved() {
        SVProgressHUD.showSuccess(withStatus: "Saved timer")
        navigationItem.rightBarButtonItem!.isEnabled = true
    }
}
