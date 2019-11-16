//
//  SensorViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 01/10/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import MaterialComponents.MaterialSlider

class ViewSensorController: UIViewController {
    
    var sensorID:Int = 0
    
    @IBOutlet weak var lightScenesBaseView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func returnToPreviousView(_ sender: UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    @IBAction func saveSchedule(_ sender: UIButton) {
        sensorController.saveSensorData(sensorID: sensorID, body: SensorsDataArray[0])
    }
    @IBOutlet weak var sensorActive: UISwitch!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var brightnessLabel: UILabel!
    
    @IBAction func activeChange(_ sender: UISwitch) {
        SensorsDataArray[0].active = sender.isOn
    }
    
    @IBAction func StartTimeTap(_ sender: UITapGestureRecognizer) {
        let dateChooserAlert = UIAlertController(title: "Select a time...", message: nil, preferredStyle: .actionSheet)
        let pickerHeight: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.frame = CGRect(x: 10, y: 30, width: self.view.frame.width, height: 150)
        datePicker.datePickerMode = .time
        
        let strDate = SensorsDataArray[0].startTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: strDate!)
        datePicker.setDate(date!, animated: false)
        dateChooserAlert.view.addSubview(datePicker)
        
        dateChooserAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
            let date = datePicker.date
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            let paddedHour =  String(format: "%02d", components.hour!)
            let minute =  "\(components.minute ?? 0)"
            let paddedMinute = minute.padding(toLength: 2, withPad: "0", startingAt: 0)
            let strTime = paddedHour + ":" + paddedMinute
            self.SensorsDataArray[0].startTime = strTime
            self.startTimeLabel.text = strTime
        }))
        dateChooserAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        dateChooserAlert.view.addConstraint(pickerHeight)
        self.present(dateChooserAlert, animated: true, completion: nil)
    }
    
    @IBAction func EndTimeTap(_ sender: UITapGestureRecognizer) {
        let dateChooserAlert = UIAlertController(title: "Select a time...", message: nil, preferredStyle: .actionSheet)
        let pickerHeight: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.frame = CGRect(x: 10, y: 30, width: self.view.frame.width, height: 150)
        datePicker.datePickerMode = .time
        
        let strDate = SensorsDataArray[0].endTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: strDate!)
        datePicker.setDate(date!, animated: false)
        dateChooserAlert.view.addSubview(datePicker)
        
        dateChooserAlert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { action in
            let date = datePicker.date
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            let paddedHour =  String(format: "%02d", components.hour!)
            let minute =  "\(components.minute ?? 0)"
            let paddedMinute = minute.padding(toLength: 2, withPad: "0", startingAt: 0)
            let strTime = paddedHour + ":" + paddedMinute
            self.SensorsDataArray[0].endTime = strTime
            self.startTimeLabel.text = strTime
        }))
        dateChooserAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        dateChooserAlert.view.addConstraint(pickerHeight)
        self.present(dateChooserAlert, animated: true, completion: nil)
    }
    
    private let sensorController = SensorController()
    
    fileprivate var SensorsDataArray = [MotionSensorsData]() {
        didSet {
            
            if (SensorsDataArray[0].active!) { sensorActive.isOn = true } else { sensorActive.isOn = false }
            
            startTimeLabel.text = SensorsDataArray[0].startTime
            endTimeLabel.text = SensorsDataArray[0].endTime
            
            let brightnessSlider = MDCSlider(frame: CGRect(x: 100, y: 70, width: 190, height: 27))
            brightnessSlider.minimumValue = 0
            brightnessSlider.maximumValue = 255
            brightnessSlider.color = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
            brightnessSlider.setValue(CGFloat(Float(SensorsDataArray[0].brightness!)), animated: true)
            brightnessSlider.isThumbHollowAtStart = false
            brightnessSlider.addTarget(self, action: #selector(brightnessSliderChange(senderSlider:)), for: .valueChanged)
            editView.addSubview(brightnessSlider)
            brightnessLabel.text = "\(SensorsDataArray[0].brightness ?? 0)"
            
            let baseLightScenes:LightScenes = Bundle.main.loadNibNamed("LightScenes", owner: self, options: nil)?.first as! LightScenes
            baseLightScenes.setScene(setSceneID: SensorsDataArray[0].scene!)
            baseLightScenes.delegate = self as LightScenesDelegate
            lightScenesBaseView.addSubview(baseLightScenes)
            
            SVProgressHUD.dismiss() // Stop spinner
            saveButton.isEnabled = true // Enable the save button
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sensorController.delegate = self
        saveButton.isEnabled = false // Disable the save button
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")
        
        saveButton.isEnabled = false // Disable the save button
        sensorController.getSensorData(sensorID: sensorID)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss() // Stop spinner
    }
    
    @objc func brightnessSliderChange(senderSlider:MDCSlider) {
        SensorsDataArray[0].brightness = Int(senderSlider.value)
        brightnessLabel.text = "\(Int(senderSlider.value))"
    }
}

extension ViewSensorController: SensorControllerDelegate {
    func didFailDataUpdateWithError(displayMsg: Bool) {
        if displayMsg {
            SVProgressHUD.showError(withStatus: "Unable to save data")
            navigationItem.rightBarButtonItem!.isEnabled = true
        } else {
            SVProgressHUD.showError(withStatus: "Network/API error")
        }
    }
    
    func sensorDidRecieveDataUpdate(data: [MotionSensorsData]) {
        SensorsDataArray = data
    }
    
    func sensorSaved() {
        SVProgressHUD.showSuccess(withStatus: "Saved settings")
        saveButton.isEnabled = true // Enable the save button
    }
}

extension ViewSensorController: LightScenesDelegate {
    func updateSceneID(sceneID: Int) {
        SensorsDataArray[0].scene = sceneID
    }
}
