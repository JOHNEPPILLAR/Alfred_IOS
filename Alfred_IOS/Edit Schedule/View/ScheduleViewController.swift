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
import MaterialComponents.MaterialSlider

class ViewScheduleController: UIViewController {

    var scheduleID:Int = 0

    @IBAction func returnToPreviousView(_ sender: UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
  
    @IBAction func saveSchedule(_ sender: UIButton) {
        scheduleController.saveScheduleData(body: ScheduleDataArray[0])
    }
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var aiEnabled: UISwitch!
    @IBOutlet weak var active: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moreDetailsView: UIView!
    @IBOutlet weak var colorLoopSwitch: UISwitch!
    @IBOutlet weak var sceneLabel: UILabel!
    @IBOutlet weak var sceneView: UIView!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var sunRiseView: UIView!
    @IBOutlet weak var dayTimeLabel: UILabel!
    @IBOutlet weak var dayTimeView: UIView!
    @IBOutlet weak var sunSetLabel: UILabel!
    @IBOutlet weak var sunSetView: UIView!
    @IBOutlet weak var eveningLabel: UILabel!
    @IBOutlet weak var eveningView: UIView!
    @IBOutlet weak var nightTimeLabel: UILabel!
    @IBOutlet weak var nightTimeView: UIView!
    @IBOutlet weak var brightnessLabel: UILabel!
    
    @IBAction func activeChange(_ sender: UISwitch) {
        ScheduleDataArray[0].active = sender.isOn
    }
    @IBAction func AIEnabledChange(_ sender: UISwitch) {
        ScheduleDataArray[0].aiOverride = sender.isOn
    }
    @IBAction func ColorLoopChange(_ sender: UISwitch) {
        ScheduleDataArray[0].colorLoop = sender.isOn
        if (sender.isOn) {
            sceneView.isHidden = true
        } else {
            sceneView.isHidden = false
        }
    }
  
    @IBAction func ChangeTimeTap(_ sender: UITapGestureRecognizer) {
        let dateChooserAlert = UIAlertController(title: "Select a time...", message: nil, preferredStyle: .actionSheet)
        let pickerHeight: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.frame = CGRect(x: 10, y: 30, width: self.view.frame.width, height: 150)
        datePicker.datePickerMode = .time
        
        let hour =  "\(ScheduleDataArray[0].hour ?? 0)"
        let minute =  "\(ScheduleDataArray[0].minute ?? 0)"
        let strDate = hour + ":" + minute
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: strDate)
        datePicker.setDate(date!, animated: false)
        dateChooserAlert.view.addSubview(datePicker)
        
        dateChooserAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
            let date = datePicker.date
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            self.ScheduleDataArray[0].hour = components.hour!
            self.ScheduleDataArray[0].minute = components.minute!
            
            let paddedHour =  String(format: "%02d", self.ScheduleDataArray[0].hour!)
            let minute =  "\(self.ScheduleDataArray[0].minute ?? 0)"
            let paddedMinute = minute.padding(toLength: 2, withPad: "0", startingAt: 0)
            let strTime = paddedHour + ":" + paddedMinute
            self.timeLabel.text = strTime
            
        }))
        dateChooserAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        dateChooserAlert.view.addConstraint(pickerHeight)
        self.present(dateChooserAlert, animated: true, completion: nil)
    }
    
    @IBAction func sunRiseSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.white
        sunRiseView.backgroundColor = UIColor.darkGray
        dayTimeLabel.textColor = UIColor.black
        dayTimeView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        sunSetLabel.textColor = UIColor.black
        sunSetView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        eveningLabel.textColor = UIColor.black
        eveningView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        nightTimeLabel.textColor = UIColor.black
        nightTimeView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        ScheduleDataArray[0].scene = 1
    }
    
    @IBAction func dayTimeSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.black
        sunRiseView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        dayTimeLabel.textColor = UIColor.white
        dayTimeView.backgroundColor = UIColor.darkGray
        sunSetLabel.textColor = UIColor.black
        sunSetView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        eveningLabel.textColor = UIColor.black
        eveningView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        nightTimeLabel.textColor = UIColor.black
        nightTimeView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        ScheduleDataArray[0].scene = 2
    }
    @IBAction func sunSetSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.black
        sunRiseView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        dayTimeLabel.textColor = UIColor.black
        dayTimeView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        sunSetLabel.textColor = UIColor.white
        sunSetView.backgroundColor = UIColor.darkGray
        eveningLabel.textColor = UIColor.black
        eveningView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        nightTimeLabel.textColor = UIColor.black
        nightTimeView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        ScheduleDataArray[0].scene = 3
    }
    @IBAction func eveningSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.black
        sunRiseView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        dayTimeLabel.textColor = UIColor.black
        dayTimeView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        sunSetLabel.textColor = UIColor.black
        sunSetView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        eveningLabel.textColor = UIColor.white
        eveningView.backgroundColor = UIColor.darkGray
        nightTimeLabel.textColor = UIColor.black
        nightTimeView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        ScheduleDataArray[0].scene = 4
    }
    @IBAction func nightTimeSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.black
        sunRiseView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        dayTimeLabel.textColor = UIColor.black
        dayTimeView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        sunSetLabel.textColor = UIColor.black
        sunSetView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        eveningLabel.textColor = UIColor.black
        eveningView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        nightTimeLabel.textColor = UIColor.white
        nightTimeView.backgroundColor = UIColor.darkGray
        ScheduleDataArray[0].scene = 5
    }
    
    private let scheduleController = ScheduleController()
    
    fileprivate var ScheduleDataArray = [SchedulesData]() {
        didSet {
            name.text = ScheduleDataArray[0].name
            if (ScheduleDataArray[0].aiOverride!) { aiEnabled.isOn = true } else { aiEnabled.isOn = false }
            if (ScheduleDataArray[0].active!) { active.isOn = true } else { active.isOn = false }

            let paddedHour =  String(format: "%02d", ScheduleDataArray[0].hour!)
            let minute =  "\(ScheduleDataArray[0].minute ?? 0)"
            let paddedMinute = minute.padding(toLength: 2, withPad: "0", startingAt: 0)
            let strTime = paddedHour + ":" + paddedMinute
            timeLabel.text = strTime
            
            switch ScheduleDataArray[0].type {
            case 1?:
                moreDetailsView.isHidden = false
                if (ScheduleDataArray[0].colorLoop!) {
                    colorLoopSwitch.isOn = true
                    sceneView.isHidden = true
                } else {
                    colorLoopSwitch.isOn = false
                    sceneView.isHidden = false
                }

                let brightnessSlider = MDCSlider(frame: CGRect(x: 107, y: 28, width: 204, height: 30))
                brightnessSlider.minimumValue = 0
                brightnessSlider.maximumValue = 255
                brightnessSlider.color = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
                brightnessSlider.value = CGFloat(Float(ScheduleDataArray[0].brightness ?? 0))
                brightnessSlider.addTarget(self, action: #selector(brightnessSliderChange(senderSlider:)), for: .valueChanged)
                moreDetailsView.addSubview(brightnessSlider)
                brightnessLabel.text = "\(ScheduleDataArray[0].brightness ?? 0)"
                
                switch ScheduleDataArray[0].scene {
                case 1:
                    sunRiseLabel.textColor = UIColor.white
                    sunRiseView.backgroundColor = UIColor.darkGray
                case 2:
                    dayTimeLabel.textColor = UIColor.white
                    dayTimeView.backgroundColor = UIColor.darkGray
                case 3:
                    sunSetLabel.textColor = UIColor.white
                    sunSetView.backgroundColor = UIColor.darkGray
                case 4:
                    eveningLabel.textColor = UIColor.white
                    eveningView.backgroundColor = UIColor.darkGray
                case 5:
                    nightTimeLabel.textColor = UIColor.white
                    nightTimeView.backgroundColor = UIColor.darkGray
                default:
                    dayTimeLabel.textColor = UIColor.white
                    dayTimeView.backgroundColor = UIColor.darkGray
                    ScheduleDataArray[0].scene = 2
                }
                default: moreDetailsView.isHidden = true
            }

            SVProgressHUD.dismiss() // Stop spinner
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")
        scheduleController.getScheduleData(scheduleID: scheduleID)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss() // Stop spinner
    }

    @objc func brightnessSliderChange(senderSlider:MDCSlider) {
        ScheduleDataArray[0].brightness = Int(senderSlider.value)
        brightnessLabel.text = "\(Int(senderSlider.value))"
    }
}

extension ViewScheduleController: ScheduleControllerDelegate {    
    func didFailDataUpdateWithError(displayMsg: Bool) {
        if displayMsg {
            SVProgressHUD.showError(withStatus: "Unable to save data")
            //navigationItem.rightBarButtonItem!.isEnabled = true
        } else {
            SVProgressHUD.showError(withStatus: "Network/API error")
        }
    }
    
    func scheduleDidRecieveDataUpdate(data: [SchedulesData]) {
        ScheduleDataArray = data
    }

    func scheduleSaved() {
        SVProgressHUD.showSuccess(withStatus: "Saved schedule")
        name.isEnabled = true
        active.isEnabled = true
    }
}

