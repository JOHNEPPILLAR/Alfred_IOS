//
//  ColorViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 07/08/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit

protocol colorPickerDelegate: class {
    func backFromColorPicker(_ color: UIColor?, ct: Int?, scene: Bool?)
}

class ColorViewController: UIViewController {
    
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var sceneButton: UIButton!
    @IBOutlet weak var sceneView: UIView!
    @IBOutlet weak var colorView: UIView!

    @IBOutlet weak var concentrateImage: RoundImage!
    @IBOutlet weak var energiseImage: RoundImage!
    @IBOutlet weak var relaxImage: RoundImage!
    @IBOutlet weak var readImage: RoundImage!
    
    weak var delegate: colorPickerDelegate?
    var colorID: UIColor?
    var ct: Int?
    var colorViewSelected = true
    let tmpColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    
    @IBAction func colorButton(_ sender: UIButton) {
        sceneView.isHidden = true
        colorViewSelected = true
        colorView.isHidden = false
    }

    @IBAction func sceneButton(_ sender: UIButton) {
        colorView.isHidden = true
        colorViewSelected = false
        sceneView.isHidden = false
    }
    
    @IBAction func concentrateTap(_ sender: Any) {
        ct = 233
        concentrateImage.layer.borderWidth = 5
        energiseImage.layer.borderWidth = 0
        relaxImage.layer.borderWidth = 0
        readImage.layer.borderWidth = 0
    }
    
    @IBAction func energiseTap(_ sender: Any) {
        ct = 156
        concentrateImage.layer.borderWidth = 0
        energiseImage.layer.borderWidth = 5
        relaxImage.layer.borderWidth = 0
        readImage.layer.borderWidth = 0
    }
    
    @IBAction func readTap(_ sender: Any) {
        ct = 348
        concentrateImage.layer.borderWidth = 0
        energiseImage.layer.borderWidth = 0
        relaxImage.layer.borderWidth = 0
        readImage.layer.borderWidth = 5
}
    
    @IBAction func relaxTap(_ sender: Any) {
        ct = 454
        concentrateImage.layer.borderWidth = 0
        energiseImage.layer.borderWidth = 0
        relaxImage.layer.borderWidth = 5
        readImage.layer.borderWidth = 0
    }
    
    @IBAction func cancelButton(_ sender: RoundButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func SaveButton(_ sender: RoundButton) {
        if colorViewSelected {
            delegate?.backFromColorPicker(colorID, ct: nil, scene: false)
        } else {
            delegate?.backFromColorPicker(nil, ct: ct, scene: true)
        }
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show the scene view and hide the color picker view
        colorView.isHidden = true
        sceneView.isHidden = false
        colorViewSelected = false

        // Draw the color picker
        var i:CGFloat = 1.0
        var buttonFrame = CGRect(x: 3, y: 0, width: 26, height: 26)
        while i > 0 {
            makeRainbowButtons(buttonFrame: buttonFrame, sat: i ,bright: 1.0)
            i = i - 0.1
            buttonFrame.origin.y = buttonFrame.origin.y + buttonFrame.size.height
        }
        
        // Set correct background color for scene images
        concentrateImage.backgroundColor = HueColorHelper.getColorFromScene(233)
        concentrateImage.layer.borderColor = UIColor.white.cgColor
        concentrateImage.layer.borderWidth = 0
        energiseImage.backgroundColor = HueColorHelper.getColorFromScene(156)
        energiseImage.layer.borderColor = UIColor.white.cgColor
        energiseImage.layer.borderWidth = 0
        relaxImage.backgroundColor = HueColorHelper.getColorFromScene(454)
        relaxImage.layer.borderColor = UIColor.white.cgColor
        relaxImage.layer.borderWidth = 0
        readImage.backgroundColor = HueColorHelper.getColorFromScene(348)
        readImage.layer.borderColor = UIColor.white.cgColor
        readImage.layer.borderWidth = 0

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
            aButton.addTarget(self, action: #selector(selectColor(_:)), for: UIControl.Event.touchUpInside)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func selectColor(_ sender: UIButton){
        
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
