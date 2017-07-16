//
//  LogFileData.swift
//  Alfred_IOS
//
//  Created by John Pillar on 10/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit

class LogFileData {
    
    var level: String?
    var message: String?
    var timestamp: String?
    
    init(json: NSDictionary) {
        self.level = json["level"] as? String
        self.message = json["message"] as? String
        self.timestamp = json["timestamp"] as? String
    }
}

class LightData {
    
    var lightID: String?
    var name: String?
    var onoff: String?
    var brightness: String?
    var x: String?
    var y: String?
    
    init(json: NSDictionary) {
        self.lightID = json["lightID"] as? String
        self.name = json["name"] as? String
        self.onoff = json["onoff"] as? String
        self.brightness = json["brightness"] as? String
        self.x = json["x"] as? String
        self.y = json["y"] as? String
    }
}


