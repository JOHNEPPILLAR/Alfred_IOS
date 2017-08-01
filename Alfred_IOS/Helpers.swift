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


