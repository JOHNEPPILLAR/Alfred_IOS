//
//  ColorSlider.swift
//  Alfred_IOS
//
//  Created by John Pillar on 01/06/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit

class ColorSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 29.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
}

extension UISlider {
    open override func addSubview(_ view: UIView) {
        super.addSubview(view)
        if view.isKind(of: UIImageView.classForCoder()) {
            view.contentMode = .left
        }
    }
    
    open func setMinimumTrackImage(startColor: UIColor, endColor: UIColor, startPoint: CGPoint, endPoint: CGPoint) -> Void {
    
        let size = CGSize.init(width: self.bounds.width, height: 29)
        let gradient = CIFilter(name: "CILinearGradient", parameters: [:])

        guard gradient != nil else {
            return
        }

        gradient?.setDefaults()
        
        let startVector = CIVector(x: startPoint.x*size.width, y: startPoint.y*size.height)
        let endVector   = CIVector(x: endPoint.x*size.width,   y: endPoint.y*size.height)
        
        gradient?.setValue(CIColor.init(color: startColor), forKey: "inputColor0")
        gradient?.setValue(CIColor.init(color: endColor), forKey: "inputColor1")
        gradient?.setValue(startVector, forKey: "inputPoint0")
        gradient?.setValue(endVector, forKey: "inputPoint1")
        
        let ciImage = gradient?.outputImage
        let context = CIContext.init(options: nil)
        let resultCGImage = context.createCGImage(ciImage!, from: CGRect.init(origin: CGPoint.zero, size: size))
        let image = UIImage.init(cgImage: resultCGImage!)
        self.setMinimumTrackImage(image, for: UIControl.State.normal)
        self.setMinimumTrackImage(image, for: UIControl.State.highlighted)
    }
}
