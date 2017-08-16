//
//  ColorViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 07/08/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit

protocol colorPickerDelegate: class {
    func backFromColorPicker(_ color: UIColor?)
}

class ColorViewController: UIViewController {
    
    weak var delegate: colorPickerDelegate?
    var colorID: UIColor?
    
    @IBAction func cancelButton(_ sender: RoundButton) {
        
        self.dismiss(animated: true)
        
    }
    
    @IBAction func SaveButton(_ sender: RoundButton) {
        
        delegate?.backFromColorPicker(colorID)
        
        self.dismiss(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Draw the color picker
        var i:CGFloat = 1.0
        var buttonFrame = CGRect(x: 27, y: 173, width: 26, height: 26)
        while i > 0 {
            makeRainbowButtons(buttonFrame: buttonFrame, sat: i ,bright: 1.0)
            i = i - 0.1
            buttonFrame.origin.y = buttonFrame.origin.y + buttonFrame.size.height
        }
        
    }
    
    func makeRainbowButtons(buttonFrame: CGRect, sat: CGFloat, bright: CGFloat) {
        var myButtonFrame = buttonFrame
        
        for i in 0..<12 {
            let hue: CGFloat = CGFloat(i) / 12.0
            let color = UIColor(hue: hue, saturation: sat, brightness: bright, alpha: 1.0)
            let aButton = UIButton(frame: myButtonFrame)
            myButtonFrame.origin.x = myButtonFrame.size.width + myButtonFrame.origin.x
            aButton.backgroundColor = color
            view.addSubview(aButton)
            aButton.addTarget(self, action: #selector(selectColor(_:)), for: .touchUpInside)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectColor(_ sender: UIButton){
        
        // Update the local color store
        colorID = sender.backgroundColor!
        
        // Remove any previous highlighted cels
        for case let button as UIButton in self.view.subviews {
            button.layer.borderWidth = 0
        }
        
        // Highlight the current selected cell
        sender.layer.borderWidth = 3
        sender.layer.borderColor = UIColor.black.cgColor
        
    }
    
}
