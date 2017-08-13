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
 
    public func rgb() -> (red:Float, green:Float, blue:Float, alpha:Float)? {

        var r:CGFloat = 0,
            g:CGFloat = 0,
            b:CGFloat = 0,
            a:CGFloat = 0,
            h:CGFloat = 0,
            s:CGFloat = 0,
            l:CGFloat = 0
        
        if self.getHue(&h, saturation: &s, brightness: &l, alpha: &a) {
            if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
                
                let fRed =  Float(r*255)
                let fGreen = Float(g*255)
                let fBlue = Float(b*255)
                let fAlpha = Float(a)
                
                return (red: fRed, green: fGreen, blue: fBlue, alpha: fAlpha)
                
            } else {
                return nil
            }
        } else {
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

