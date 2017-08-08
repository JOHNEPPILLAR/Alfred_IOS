//
//  ColorViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 07/08/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import IMGLYColorPicker

class ColorViewController: UIViewController {

    @IBOutlet weak var colorPicker: ColorPickerView!
    
    @IBAction func cancelButton(_ sender: RoundButton) {
        
        //cellID.sharedInstance.cell = nil
        self.dismiss(animated: true)
        
    }
    
    @IBAction func SaveButton(_ sender: RoundButton) {

        let cell = cellID.sharedInstance.cell
        cell?.powerButton.backgroundColor = colorPicker.color
        //cellID.sharedInstance.cell = nil
        self.dismiss(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cell = cellID.sharedInstance.cell
        var color = cell?.powerButton.backgroundColor
        if color == nil {
            color = UIColor.white
        }
    
        self.colorPicker.color = color!

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
