//
//  SensorsTableViewCell.swift
//  Alfred_IOS
//
//  Created by John Pillar on 01/10/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSlider

class SensorsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sensorNameLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var sliderView: UIView!
    
    func configureWithItem(item: SensorsRows) {
        
        switch item.sensorId {
        case 1:
            sensorNameLabel.text = "Front hall"
        case 2:
            sensorNameLabel.text = "Living room"
        case 3:
            sensorNameLabel.text = "Middle hall"
        default:
            sensorNameLabel.text = "Not defined"
        }
        
        timerLabel.text = item.startTime! + " to " + item.endTime!
        
        let brightnessSlider = MDCSlider(frame: CGRect(x: 10, y: 10, width: 100, height: 27))
        brightnessSlider.minimumValue = 0
        brightnessSlider.maximumValue = 255
        brightnessSlider.color = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
        brightnessSlider.value = CGFloat(item.brightness!)
        brightnessSlider.isUserInteractionEnabled = false;
        sliderView.addSubview(brightnessSlider)
    }
}
