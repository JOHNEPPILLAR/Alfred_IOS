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
            ["label": "Logs", "image": "ic_log_file", "segue": "logs"],
            ["label": "Timers", "image": "ic_alarm_clock", "segue": "timers"],
        ]
        let SettingsJSON = JSON(SettingsData)
        self.delegate?.settingsDidRecieveDataUpdate(json: SettingsJSON)
    }
}

