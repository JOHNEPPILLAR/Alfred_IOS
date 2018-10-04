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
    @IBOutlet weak var sensorName: UITextField!
    @IBOutlet weak var sensorActive: UISwitch!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var dayTimeLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    @IBOutlet weak var eveningLabel: UILabel!
    @IBOutlet weak var nightTimeLabel: UILabel!
    @IBOutlet weak var brightnessLabel: UILabel!
    
    @IBAction func activeChange(_ sender: UISwitch) {
        SensorsDataArray[0].rows![sensorID].active = sender.isOn
    }
    
    @IBAction func sunRiseSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
        dayTimeLabel.textColor = UIColor.white
        sunSetLabel.textColor = UIColor.white
        eveningLabel.textColor = UIColor.white
        nightTimeLabel.textColor = UIColor.white
        SensorsDataArray[0].rows![sensorID].scene = 1
    }
    
    @IBAction func dayTimeSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.white
        dayTimeLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
        sunSetLabel.textColor = UIColor.white
        eveningLabel.textColor = UIColor.white
        nightTimeLabel.textColor = UIColor.white
        SensorsDataArray[0].rows![sensorID].scene = 2
    }
    @IBAction func sunSetSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.white
        dayTimeLabel.textColor = UIColor.white
        sunSetLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
        eveningLabel.textColor = UIColor.white
        nightTimeLabel.textColor = UIColor.white
        SensorsDataArray[0].rows![sensorID].scene = 3
    }
    @IBAction func eveningSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.white
        dayTimeLabel.textColor = UIColor.white
        sunSetLabel.textColor = UIColor.white
        eveningLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
        nightTimeLabel.textColor = UIColor.white
        SensorsDataArray[0].rows![sensorID].scene = 4
    }
    @IBAction func nightTimeSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.white
        dayTimeLabel.textColor = UIColor.white
        sunSetLabel.textColor = UIColor.white
        eveningLabel.textColor = UIColor.white
        nightTimeLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
        SensorsDataArray[0].rows![sensorID].scene = 5
    }
  
    @IBAction func StartTimeTap(_ sender: UITapGestureRecognizer) {
        let dateChooserAlert = UIAlertController(title: "Select a time...", message: nil, preferredStyle: .actionSheet)
        let pickerHeight: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.frame = CGRect(x: 10, y: 30, width: self.view.frame.width, height: 150)
        datePicker.datePickerMode = .time
        
        let strDate = SensorsDataArray[0].rows![sensorID].startTime
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
            self.SensorsDataArray[0].rows![self.sensorID].startTime = strTime
            self.startTimeLabel.text = strTime
        }))
        dateChooserAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        dateChooserAlert.view.addConstraint(pickerHeight)
        self.present(dateChooserAlert, animated: true, completion: nil)
    }
    
    @IBAction func EndTimeTap(_ sender: UITapGestureRecognizer) {
        let dateChooserAlert = UIAlertController(title: "Select a time...", message: nil, preferredStyle: .actionSheet)
        let pickerHeight: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.frame = CGRect(x: 10, y: 30, width: self.view.frame.width, height: 150)
        datePicker.datePickerMode = .time
        
        let strDate = SensorsDataArray[0].rows![sensorID].endTime
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
            self.SensorsDataArray[0].rows![self.sensorID].endTime = strTime
            self.startTimeLabel.text = strTime
        }))
        dateChooserAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        dateChooserAlert.view.addConstraint(pickerHeight)
        self.present(dateChooserAlert, animated: true, completion: nil)
    }
    
    private let sensorController = SensorController()
    
    fileprivate var SensorsDataArray = [SensorsData]() {
        didSet {
            
            switch SensorsDataArray[0].rows![sensorID].sensorId {
            case 1:
                sensorName.text = "Front hall"
            case 2:
                sensorName.text = "Living room"
            case 3:
                sensorName.text = "Middle hall"
            default:
                sensorName.text = "Not defined"
            }
            
            if (SensorsDataArray[0].rows![sensorID].active!) { sensorActive.isOn = true } else { sensorActive.isOn = false }
            
            startTimeLabel.text = SensorsDataArray[0].rows![sensorID].startTime
            endTimeLabel.text = SensorsDataArray[0].rows![sensorID].endTime
            
            let brightnessSlider = MDCSlider(frame: CGRect(x: 100, y: 121, width: 190, height: 27))
            brightnessSlider.minimumValue = 0
            brightnessSlider.maximumValue = 255
            brightnessSlider.color = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
            brightnessSlider.setValue(CGFloat(Float(SensorsDataArray[0].rows![sensorID].brightness!)), animated: true)
            brightnessSlider.isThumbHollowAtStart = false
            brightnessSlider.addTarget(self, action: #selector(brightnessSliderChange(senderSlider:)), for: .valueChanged)
            editView.addSubview(brightnessSlider)
            brightnessLabel.text = "\(SensorsDataArray[0].rows![sensorID].brightness ?? 0)"
            
            switch SensorsDataArray[0].rows![sensorID].scene {
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
                dayTimeLabel.textColor = UIColor(red: 118/255.0, green: 214/255.0, blue:114/255.0, alpha: 1.0)
                SensorsDataArray[0].rows![sensorID].scene = 2
            }
            
            SVProgressHUD.dismiss() // Stop spinner
            self.navigationItem.rightBarButtonItem?.isEnabled = true // Enable the save button
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sensorController.delegate = self
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
        
        sensorController.getSensorData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss() // Stop spinner
    }
    
    @objc func saveSettingsAction(sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false // Disable the save button
        sensorController.saveSensorData(body: SensorsDataArray[0].rows![sensorID])
    }
    
    @objc func brightnessSliderChange(senderSlider:MDCSlider) {
        SensorsDataArray[0].rows![sensorID].brightness = Int(senderSlider.value)
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
    
    func sensorDidRecieveDataUpdate(data: [SensorsData]) {
        SensorsDataArray = data
    }
    
    func sensorSaved() {
        SVProgressHUD.showSuccess(withStatus: "Saved timer")
        navigationItem.rightBarButtonItem!.isEnabled = true
    }
}
