//
//  LightsCollectionViewCell.swift
//  Alfred_IOS
//
//  Created by John Pillar on 03/08/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit

class LightsTableViewCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    
    @IBOutlet weak var powerButton: UIImageView!
    @IBOutlet weak var lightName: UITextField!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var lightID: UITextField!
    @IBOutlet weak var lightState: UISwitch!
    
    func configureWithItem(item: RoomLightsData) {
        
        lightID.text = item.attributes?.attributes?.id
        lightState.isOn = (item.state?.attributes?.anyOn)!
        lightName.text = item.attributes?.attributes?.name
        
        brightnessSlider.value = Float((item.action?.attributes?.bri)!)
        brightnessSlider.tag = Int((item.attributes?.attributes?.id)!)!
        
        // Configure the power button
        if (item.state?.attributes?.anyOn)! {
            
            // Setup the light bulb colour
            var color = UIColor.white
            switch item.action?.attributes?.colormode {
            case "ct"?: color = HueColorHelper.getColorFromScene((item.action?.attributes?.ct)!)
            case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((item.action?.attributes?.xy![0])!), y: Double((item.action?.attributes?.xy![1])!)), forModel: "LCT007")
                default: color = UIColor.white
            }
            powerButton.backgroundColor = color
            brightnessSlider.isHidden = false
        } else {
            powerButton.backgroundColor = UIColor.clear
            brightnessSlider.isHidden = true
        }
        powerButton.isUserInteractionEnabled = true
    }
}
