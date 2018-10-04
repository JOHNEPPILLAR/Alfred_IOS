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

class ViewTimerController: UIViewController {

    var timerID:Int = 0

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var aiEnabled: UISwitch!
    @IBOutlet weak var active: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moreDetailsView: UIView!
    @IBOutlet weak var colorLoopSwitch: UISwitch!
    @IBOutlet weak var sceneLabel: UILabel!
    @IBOutlet weak var sceneView: UIView!
    @IBOutlet weak var lightGroupText: UITextField!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var dayTimeLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    @IBOutlet weak var eveningLabel: UILabel!
    @IBOutlet weak var nightTimeLabel: UILabel!
    @IBOutlet weak var brightnessLabel: UILabel!
    
    @IBAction func activeChange(_ sender: UISwitch) {
        TimersDataArray[0].rows![timerID].active = sender.isOn
    }
    @IBAction func AIEnabledChange(_ sender: UISwitch) {
        TimersDataArray[0].rows![timerID].aiOverride = sender.isOn
    }
    @IBAction func ColorLoopChange(_ sender: UISwitch) {
        if (sender.isOn) {
            sceneView.isHidden = true
        } else {
            sceneView.isHidden = false
        }
        TimersDataArray[0].rows![timerID].color_loop = sender.isOn
    }
  
    @IBAction func ChangeTimeTap(_ sender: UITapGestureRecognizer) {
        let dateChooserAlert = UIAlertController(title: "Select a time...", message: nil, preferredStyle: .actionSheet)
        let pickerHeight: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.frame = CGRect(x: 10, y: 30, width: self.view.frame.width, height: 150)
        datePicker.datePickerMode = .time
        
        let hour =  "\(TimersDataArray[0].rows![timerID].hour ?? 0)"
        let minute =  "\(TimersDataArray[0].rows![timerID].minute ?? 0)"
        let strDate = hour + ":" + minute
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: strDate)
        datePicker.setDate(date!, animated: false)
        dateChooserAlert.view.addSubview(datePicker)
        
        dateChooserAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
            let date = datePicker.date
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            self.TimersDataArray[0].rows![self.timerID].hour = components.hour!
            self.TimersDataArray[0].rows![self.timerID].minute = components.minute!
            
            let paddedHour =  String(format: "%02d", self.TimersDataArray[0].rows![self.timerID].hour!)
            let minute =  "\(self.TimersDataArray[0].rows![self.timerID].minute ?? 0)"
            let paddedMinute = minute.padding(toLength: 2, withPad: "0", startingAt: 0)
            let strTime = paddedHour + ":" + paddedMinute
            self.timeLabel.text = strTime
            
        }))
        dateChooserAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        dateChooserAlert.view.addConstraint(pickerHeight)
        self.present(dateChooserAlert, animated: true, completion: nil)
    }
    
    @IBAction func RoomChangeTap(_ sender: UITapGestureRecognizer) {
        let roomChooserAlert = UIAlertController(title: "Select a room...", message: nil, preferredStyle: .actionSheet)
        let pickerHeight: NSLayoutConstraint = NSLayoutConstraint(item: roomChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        let pickerFrame = CGRect(x: 0, y: 30, width: self.view.frame.width, height: 160)
        let roomPicker: UIPickerView = UIPickerView(frame: pickerFrame);
        roomPicker.dataSource = self
        roomPicker.delegate = self
        
        var selectedRoomIndex = RoomLightsDataArray.index(where: { $0.attributes?.attributes!.id == "\(self.TimersDataArray[0].rows![self.timerID].light_group_number ?? 0)" })
        if(selectedRoomIndex == nil) { selectedRoomIndex = 0 }
        roomPicker.selectRow(selectedRoomIndex!, inComponent: 0, animated: false)
        
        roomChooserAlert.view.addSubview(roomPicker);
        roomChooserAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
            let selectedRoom = self.RoomLightsDataArray.compactMap({ $0 }).filter { (($0.attributes?.attributes?.id!.contains("\(self.TimersDataArray[0].rows![self.timerID].light_group_number ?? 0)" ))!) }
            self.lightGroupText.text = selectedRoom[0].attributes?.attributes?.name
        }))
        roomChooserAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        roomChooserAlert.view.addConstraint(pickerHeight)
        self.present(roomChooserAlert, animated: true, completion: nil)
    }
    
    @IBAction func sunRiseSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
        dayTimeLabel.textColor = UIColor.white
        sunSetLabel.textColor = UIColor.white
        eveningLabel.textColor = UIColor.white
        nightTimeLabel.textColor = UIColor.white
        TimersDataArray[0].rows![timerID].scene = 1
    }
    
    @IBAction func dayTimeSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.white
        dayTimeLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
        sunSetLabel.textColor = UIColor.white
        eveningLabel.textColor = UIColor.white
        nightTimeLabel.textColor = UIColor.white
        TimersDataArray[0].rows![timerID].scene = 2
    }
    @IBAction func sunSetSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.white
        dayTimeLabel.textColor = UIColor.white
        sunSetLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
        eveningLabel.textColor = UIColor.white
        nightTimeLabel.textColor = UIColor.white
        TimersDataArray[0].rows![timerID].scene = 3
    }
    @IBAction func eveningSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.white
        dayTimeLabel.textColor = UIColor.white
        sunSetLabel.textColor = UIColor.white
        eveningLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
        nightTimeLabel.textColor = UIColor.white
        TimersDataArray[0].rows![timerID].scene = 4
    }
    @IBAction func nightTimeSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.white
        dayTimeLabel.textColor = UIColor.white
        sunSetLabel.textColor = UIColor.white
        eveningLabel.textColor = UIColor.white
        nightTimeLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
        TimersDataArray[0].rows![timerID].scene = 5
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
            
            switch TimersDataArray[0].rows![timerID].type {
            case 4,5,6?:
                moreDetailsView.isHidden = false
                if (TimersDataArray[0].rows![timerID].color_loop!) {
                    colorLoopSwitch.isOn = true
                    sceneView.isHidden = true
                } else {
                    colorLoopSwitch.isOn = false
                    sceneView.isHidden = false
                }

                let brightnessSlider = MDCSlider(frame: CGRect(x: 107, y: 82, width: 204, height: 27))
                brightnessSlider.minimumValue = 0
                brightnessSlider.maximumValue = 255
                brightnessSlider.color = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
                brightnessSlider.value = CGFloat(Float(TimersDataArray[0].rows![timerID].brightness!))
                brightnessSlider.addTarget(self, action: #selector(roomSliderChange(senderSlider:)), for: .valueChanged)
                moreDetailsView.addSubview(brightnessSlider)
                brightnessLabel.text = "\(TimersDataArray[0].rows![timerID].brightness ?? 0)"
                
                switch TimersDataArray[0].rows![timerID].scene {
                case 1:
                    sunRiseLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
                case 2:
                    dayTimeLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
                case 3:
                    sunSetLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
                case 4:
                    eveningLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
                case 5:
                    nightTimeLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
                default:
                    dayTimeLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
                    TimersDataArray[0].rows![timerID].scene = 2
                }
                
                // Get light group data
                timerController.getLightRoomData()
                
            default: moreDetailsView.isHidden = true
            }
            
            if (moreDetailsView.isHidden) {
                SVProgressHUD.dismiss() // Stop spinner
                name.isEnabled = true
                active.isEnabled = true
                self.navigationItem.rightBarButtonItem?.isEnabled = true // Enable the save button
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
            
            name.isEnabled = true
            active.isEnabled = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true // Enable the save button
            SVProgressHUD.dismiss() // Stop spinner
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerController.delegate = self
        
        // Disable edit ui untill data is loaded
        name.isEnabled = false
        active.isEnabled = false
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
        timerController.saveTimerData(body: TimersDataArray[0].rows![timerID])
    }
    
    @objc func roomSliderChange(senderSlider:MDCSlider) {
        TimersDataArray[0].rows![timerID].brightness = Int(senderSlider.value)
        brightnessLabel.text = "\(Int(senderSlider.value))"
    }
}

extension ViewTimerController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in picker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ picker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RoomLightsDataArray.count
    }
    
    func pickerView(_ picker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return RoomLightsDataArray[row].attributes?.attributes?.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        TimersDataArray[0].rows![timerID].light_group_number = Int((RoomLightsDataArray[row].attributes?.attributes?.id)!)
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
        name.isEnabled = true
        active.isEnabled = true
        navigationItem.rightBarButtonItem!.isEnabled = true
    }
    
    func lightRoomDidRecieveDataUpdate(data: [RoomLightsData]) {
        RoomLightsDataArray = data
    }
}
