//
//  PhilipsHueColors.swift
//  Alfred_IOS
//
//  Created by John Pillar on 22/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import Foundation

class Helper{

    static func getXY(red: Double, green: Double, blue: Double) -> Array<Double> {
    
        var r: Double, g: Double, b: Double
        
        if red > 0.04045 {
            r = Double(pow((red + 0.055)/(1.0 + 0.055), 2.4))
        } else {
            r = (red / 12.92);
        }
    
        if green > 0.04045 {
            g = Double(pow((green + 0.055) / (1.0 + 0.055), 2.4))
        } else {
            g = green / 12.92;
        }
        
        if blue > 0.04045 {
            b = Double(pow((blue + 0.055) / (1.0 + 0.055), 2.4))
        } else {
            b = (blue / 12.92);
        }
        
        let X = r * 0.664511 + g * 0.154324 + b * 0.162028;
        let Y = r * 0.283881 + g * 0.668433 + b * 0.047685;
        let Z = r * 0.000088 + g * 0.072310 + b * 0.986039;
        let x = X / (X + Y + Z);
        let y = Y / (X + Y + Z);
   
        return [x,y];
    }
    
    
    
}
