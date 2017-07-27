//
//  LightTableViewCell.swift
//  Alfred_IOS
//
//  Created by John Pillar on 16/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}

class LightTableViewCell: UITableViewCell {

    @IBOutlet weak var LightNameLabelEvening: UILabel!
    @IBOutlet weak var LightNameLabelMorning: UILabel!
    @IBOutlet weak var LightNameLabelEveningTV: UILabel!

    @IBOutlet weak var onOffSwitchEvening: UISwitch!
    @IBOutlet weak var onOffSwitchMorning: UISwitch!
    @IBOutlet weak var onOffSwitchEveningTV: UISwitch!
    
    @IBOutlet weak var LightBrightnessSliderEvening: UISlider!
    @IBOutlet weak var LightBrightnessSliderMorning: UISlider!
    @IBOutlet weak var LightBrightnessSliderEveningTV: UISlider!
    
    @IBOutlet weak var ColorButtonEvening: RoundButton!
    @IBOutlet weak var ColorButtonMorning: RoundButton!
    @IBOutlet weak var ColorButtonEveningTV: RoundButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
