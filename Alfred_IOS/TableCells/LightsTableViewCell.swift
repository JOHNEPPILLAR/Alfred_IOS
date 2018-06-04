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
    
    @IBOutlet weak var lightName: UITextField!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var lightID: UITextField!
    @IBOutlet weak var lightState: UISwitch!
    @IBOutlet weak var cellBackgroundView: RoundCornersView!
    
    func configureWithItem(item: RoomLightsData) {
        var color = UIColor(red: 30/255, green: 34/255, blue: 60/255, alpha: 0.5)
        lightID.text = item.attributes?.attributes?.id
        lightState.isOn = (item.state?.attributes?.anyOn)!
        lightState.tag = Int((item.attributes?.attributes?.id)!)!
        lightName.text = item.attributes?.attributes?.name
        
        brightnessSlider.value = Float((item.action?.attributes?.bri)!)
        brightnessSlider.tag = Int((item.attributes?.attributes?.id)!)!

        // Configure the light color        
        if (item.state?.attributes?.anyOn)! {
            switch item.action?.attributes?.colormode {
                case "ct"?: color = HueColorHelper.getColorFromScene((item.action?.attributes?.ct)!)
                case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((item.action?.attributes?.xy![0])!), y: Double((item.action?.attributes?.xy![1])!)), forModel: "LCT007")
                case "hs"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((item.action?.attributes?.xy![0])!), y: Double((item.action?.attributes?.xy![1])!)), forModel: "LCT007")
                default: color = UIColor.white
            }
            let darkerColor = color.darker(by: -15)
            lightState.onTintColor = darkerColor
            brightnessSlider.maximumTrackTintColor = darkerColor
            brightnessSlider.setMinimumTrackImage(startColor: darkerColor!,
                                                  endColor: UIColor.white,
                                                  startPoint: CGPoint.init(x: 0, y: 0),
                                                  endPoint: CGPoint.init(x: 1, y: 1))
            brightnessSlider.layer.cornerRadius = 12.0;
            brightnessSlider.isHidden = false
        } else {
            brightnessSlider.isHidden = true
        }
        cellBackgroundView.backgroundColor = color
        lightName.textColor = cellBackgroundView.backgroundColor?.isDarkColor == true ? .white : .black
    }
}
