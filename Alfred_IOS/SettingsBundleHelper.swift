//
//  SettingsBundleHelper.swift
//  Alfred_IOS
//
//  Created by John Pillar on 18/09/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import Foundation

class SettingsBundleHelper {
    
    class func setVersionAndBuildNumber() {

        let infoPlist = Bundle.main.infoDictionary
        //let userDefaults = UserDefaults.standard
        
        let version: String = infoPlist!["CFBundleShortVersionString"] as! String
        UserDefaults.standard.setValue(version, forKey: "version_preference")
        //userDefaults.set(version, forKey: "version_preference")
        
        let build: String = infoPlist!["CFBundleVersion"] as! String
        UserDefaults.standard.setValue(build, forKey: "build_preference")
        //userDefaults.set(build, forKey: "build_preference")

        UserDefaults.standard.synchronize()
        
    }
    
}
