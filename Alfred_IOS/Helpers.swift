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
        //layer.borderWidth = 1
        //layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }
}

