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
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var activeImage: UIImageView!
    
    func configureWithItem(item: MotionSensorsData) {
        activeImage.image = #imageLiteral(resourceName: "ic_success")
        if !item.active! { activeImage.image = #imageLiteral(resourceName: "ic_error") }
        
       startTimeLabel.text = item.startTime
       endTimeLabel.text = item.endTime

        let brightnessSlider = MDCSlider(frame: CGRect(x: 10, y: 2, width: 170, height: 27))
        brightnessSlider.minimumValue = 0
        brightnessSlider.maximumValue = 255
        brightnessSlider.color = UIColor(red: 118/255.0, green: 214/255.0, blue: 114/255.0, alpha: 1.0)
        brightnessSlider.value = CGFloat(item.brightness!)
        brightnessSlider.isUserInteractionEnabled = false;
        sliderView.addSubview(brightnessSlider)
    }
}
