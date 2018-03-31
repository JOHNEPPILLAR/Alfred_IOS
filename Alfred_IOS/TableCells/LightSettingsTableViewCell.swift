//
//  LightSettings.swift
//  Alfred_IOS
//
//  Created by John Pillar on 31/03/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit

class LightSettingsTableViewCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    
    @IBOutlet weak var powerButton: UIImageView!
    @IBOutlet weak var lightName: UITextField!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var lightID: UITextField!
    @IBOutlet weak var lightState: UISwitch!
    
    func configureWithItem(row: Int, item: SettingsLights) {
        
        lightID.text = item.lightID!.stringValue
        lightName.text = item.lightName
        brightnessSlider.value = Float(item.brightness!)
        brightnessSlider.tag = row
        
        // Configure the power button
        powerButton.tag = row
        if (item.onoff == "on") {
            lightState.isOn = true

            // Setup the light bulb colour
            var color = UIColor.white
            switch item.colormode {
            case "ct"?: color = HueColorHelper.getColorFromScene((item.ct)!)
            case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double(item.xy![0]), y: Double(item.xy![1])), forModel: "LCT007")
            default: color = UIColor.white
            }
            powerButton.backgroundColor = color
        } else {
            powerButton.backgroundColor = UIColor.clear
        }
        powerButton.isUserInteractionEnabled = true
 
    }
}
