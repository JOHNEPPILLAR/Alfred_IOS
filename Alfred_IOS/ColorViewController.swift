//
//  ColorViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 07/08/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import IMGLYColorPicker

protocol colorPickerDelegate: class {
    func backFromColorPicker(_ color: UIColor?)
}

class ColorViewController: UIViewController {

    weak var delegate: colorPickerDelegate?
    var colorID: UIColor?
    
    @IBOutlet weak var colorPicker: ColorPickerView!
    @IBOutlet weak var calledby: UIViewController!
    
    @IBAction func cancelButton(_ sender: RoundButton) {
        
        self.dismiss(animated: true)
        
    }
    
    @IBAction func SaveButton(_ sender: RoundButton) {

        delegate?.backFromColorPicker(colorPicker.color)

        self.dismiss(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorPicker.color = colorID!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
