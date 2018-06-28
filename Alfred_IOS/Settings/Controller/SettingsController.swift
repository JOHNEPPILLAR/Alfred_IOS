//
//  SettingsController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 24/06/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: Delegate callback functions
protocol SettingsViewControllerDelegate: class {
    func settingsDidRecieveDataUpdate(json: JSON)
}

class SettingsController: NSObject {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    func getData() {
        let SettingsData: JSON = [
            ["label": "Logs", "image": "ic_logFile", "segue": "logs"],
            ["label": "Lights On", "image": "ic_lightsOn", "segue": "logs"],
            ["label": "Lights Off", "image": "ic_lightsOff", "segue": "logs"],
        ]
        let SettingsJSON = JSON(SettingsData)
        self.delegate?.settingsDidRecieveDataUpdate(json: SettingsJSON)
    }
}

