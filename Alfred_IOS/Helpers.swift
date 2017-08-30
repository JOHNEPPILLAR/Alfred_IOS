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
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }
}

@IBDesignable class Line: UIView {
    override func draw(_ rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(2.0)
        context!.setStrokeColor(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor)
        context?.move(to: CGPoint(x: 0, y: self.frame.size.height))
        context?.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        context!.strokePath()
    }
}
