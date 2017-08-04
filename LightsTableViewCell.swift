//
//  LightsTableViewCell.swift
//  Alfred_IOS
//
//  Created by John Pillar on 29/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import TGPControls

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

@IBDesignable class ReoundImage: UIImageView
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateRadius()
        }
    }
    
    func updateRadius() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        //layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }

    func setBlackBorder() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }

    func setWhiteBorder() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }

}

class LightsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lightName: UILabel!
    @IBOutlet weak var lightColor: ReoundImage!
    @IBOutlet weak var lightBrightness: TGPDiscreteSlider!
    
    @IBOutlet weak var brightnessSliderBg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
