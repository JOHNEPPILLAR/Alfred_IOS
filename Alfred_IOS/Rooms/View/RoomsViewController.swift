//
//  RoomsViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 20/01/2019.
//  Copyright © 2019 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

class RoomsViewController: UIViewController {

    var roomID:Int = 0
    
    @IBAction func returnToPreviousView(_ sender: UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    
    @IBOutlet weak var roomName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roomName.text = "\(roomID)"
    
    }
   

}
