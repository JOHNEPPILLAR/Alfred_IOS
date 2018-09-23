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
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moreDetailsView: UIView!
    @IBOutlet weak var colorLoopSwitch: UISwitch!
    @IBOutlet weak var brightness: UISlider!
    @IBOutlet weak var sceneLabel: UILabel!
    @IBOutlet weak var sceneText: UITextField!
    @IBOutlet weak var lightGroupText: UITextField!
    @IBOutlet weak var sceneMoreButton: UIView!
    @IBAction func ChangeColorLoop(_ sender: UISwitch) {
        if (sender.isOn) {
            sceneMoreButton.isHidden = true
            sceneText.isHidden = true
            sceneLabel.isHidden = true
        } else {
            sceneMoreButton.isHidden = false
            sceneText.isHidden = false
            sceneLabel.isHidden = false
        }
        TimersDataArray[0].rows![timerID].color_loop = sender.isOn
    }
    
    private let timerController = TimerController()
    
    fileprivate var TimersDataArray = [TimersData]() {
        didSet {
            name.text = TimersDataArray[0].rows![timerID].name
            if (TimersDataArray[0].rows![timerID].aiOverride!) { aiEnabled.isOn = true } else { aiEnabled.isOn = false }
            if (TimersDataArray[0].rows![timerID].active!) { active.isOn = true } else { active.isOn = false }

            let paddedHour =  String(format: "%02d", TimersDataArray[0].rows![timerID].hour!)
            let minute =  "\(TimersDataArray[0].rows![timerID].minute ?? 0)"
            let paddedMinute = minute.padding(toLength: 2, withPad: "0", startingAt: 0)
            let strTime = paddedHour + ":" + paddedMinute
            timeLabel.text = strTime
            
            // Enable edit of data
            name.isEnabled = true
            active.isEnabled = true
            aiEnabled.isEnabled = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true // Enable the save button
            
            switch TimersDataArray[0].rows![timerID].type {
            case 4,5,6?:
                moreDetailsView.isHidden = false
                if (TimersDataArray[0].rows![timerID].color_loop!) { colorLoopSwitch.isOn = true } else { colorLoopSwitch.isOn = false }
                brightness.value = Float(TimersDataArray[0].rows![timerID].brightness!)
                sceneText.text = TimersDataArray[0].rows![timerID].scene

                // Get light group data
                timerController.getLightRoomData()
                
            default: moreDetailsView.isHidden = true
            }
            
            if (moreDetailsView.isHidden) {
                SVProgressHUD.dismiss() // Stop spinner
            }
        }
    }
    
    fileprivate var RoomLightsDataArray = [RoomLightsData]() {
        didSet {
            for item in RoomLightsDataArray {
                if (item.attributes?.attributes?.id == "\(TimersDataArray[0].rows![timerID].light_group_number ?? 0)") {
                 lightGroupText.text = item.attributes?.attributes?.name
                }
            }
            SVProgressHUD.dismiss() // Stop spinner
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerController.delegate = self
        
        // Disable edit ui untill data is loaded
        name.isEnabled = false
        active.isEnabled = false
        aiEnabled.isEnabled = false
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
        let hour = TimersDataArray[0].rows![timerID].hour
        let minute = TimersDataArray[0].rows![timerID].minute
        let body = ["id": TimersDataArray[0].rows![timerID].id!, "name": name.text!, "hour": hour!, "minute": minute!, "ai_override": aiEnabled.isOn, "active": active.isOn ] as [String : Any]
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
    
    func lightRoomDidRecieveDataUpdate(data: [RoomLightsData]) {
        RoomLightsDataArray = data
    }
}
