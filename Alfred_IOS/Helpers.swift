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

class cellID {
    static var sharedInstance = cellID()
    private init() {}
    
    var cell: LightsCollectionViewCell?
}

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
    
    public func isLight() -> Bool {
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
    
    public func rgb() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            //let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return (red:iRed, green: (iGreen << 8), blue: iBlue, alpha: (iAlpha << 24))
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}

@IBDesignable class RoundButton: UIButton {
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
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }
}

@IBDesignable class RoundImage: UIImageView {
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
        layer.masksToBounds = false
        //layer.borderWidth = 1
        //layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }
}

