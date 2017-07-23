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

    @IBOutlet weak var LightNameLabel: UILabel!
       
    @IBOutlet weak var onOffSwitch: UISwitch!
    
    @IBOutlet weak var LightBrightnessSlider: UISlider!
    
    @IBOutlet weak var ColorButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
