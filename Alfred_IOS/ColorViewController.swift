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
    
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var sceneButton: UIButton!
    @IBOutlet weak var sceneView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var energiseButton: RoundButton!
    @IBOutlet weak var readingButton: RoundButton!
    @IBOutlet weak var concentrateButton: RoundButton!
    @IBOutlet weak var relaxButton: RoundButton!
    weak var delegate: colorPickerDelegate?
    var colorID: UIColor?
    var ct: Int?
    var colorViewSelected = true
    let tmpColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    
    @IBAction func colorButton(_ sender: UIButton) {
        sceneButton.backgroundColor = UIColor.clear
        sceneButton.setTitleColor(tmpColor, for: .normal)
        sceneView.isHidden = true
        colorViewSelected = true
        sender.backgroundColor = tmpColor
        sender.setTitleColor(UIColor.black, for: .normal)
        colorView.isHidden = false
//        self.view.bringSubview(toFront: colorView);
    }

    @IBAction func sceneButton(_ sender: UIButton) {
        colorButton.backgroundColor = UIColor.clear
        colorButton.setTitleColor(tmpColor, for: .normal)
        colorView.isHidden = true
        colorViewSelected = false
        sender.backgroundColor = tmpColor
        sender.setTitleColor(UIColor.black, for: .normal)
        sceneView.isHidden = false
//        self.view.bringSubview(toFront: sceneView);
    }
    
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
        colorView.isHidden = false
        sceneView.isHidden = true

        var i:CGFloat = 1.0
//        var buttonFrame = CGRect(x: 27, y: 173, width: 26, height: 26)
        var buttonFrame = CGRect(x: 3, y: 0, width: 26, height: 26)
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
            colorView.addSubview(aButton)
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
