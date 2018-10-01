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
    
    /*
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
  */
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
            
            let brightnessSlider = MDCSlider(frame: CGRect(x: 107, y: 82, width: 204, height: 27))
            brightnessSlider.minimumValue = 0
            brightnessSlider.maximumValue = 255
            brightnessSlider.color = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
            brightnessSlider.value = CGFloat(Float(SensorsDataArray[0].rows![sensorID].brightness!))
            //brightnessSlider.addTarget(self, action: #selector(roomSliderChange(senderSlider:)), for: .valueChanged)
            editView.addSubview(brightnessSlider)
                
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
            //name.isEnabled = true
            //active.isEnabled = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true // Enable the save button
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sensorController.delegate = self
        
        // Disable edit ui untill data is loaded
        //name.isEnabled = false
        //active.isEnabled = false
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
        //sensorController.saveSensorData(body: SensorsDataArray[0].rows![sensorID])
    }
    
    //@objc func roomSliderChange(senderSlider:MDCSlider) {
    //    SensorsDataArray[0].rows![sensorID].brightness = Int(senderSlider.value)
    //}
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
        //name.isEnabled = true
        //active.isEnabled = true
        navigationItem.rightBarButtonItem!.isEnabled = true
    }
}
