//
//  Helpers.swift
//  Alfred_IOS
//
//  Created by John Pillar on 23/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

func readPlist(item: String) -> String {
    
    var plistItem: String = ""
    
    if let path = Bundle.main.path(forResource: "Alfred", ofType: "plist") {
        let dictRoot = NSDictionary(contentsOfFile: path)
        if let dict = dictRoot {
            plistItem = dict[item] as! String
        }
    }
    return plistItem
    
}

public extension UIColor {
    
    public func isLight() -> Bool
    {
        let components = self.cgColor.components
        
        let firstComponent = ((components?[0])! * 299)
        let secondComponent = ((components?[1])! * 587)
        let thirdComponent = ((components?[2])! * 114)
        let brightness = (firstComponent + secondComponent + thirdComponent) / 1000
        
        if brightness < 0.5 {
            return false
        } else {
            return true
        }
    }
}

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
        //layer.borderWidth = 1
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

