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
    
    var lightID: Int?
    var lightName: String?
    var onoff: String?
    var brightness: Int?
    var x: Double?
    var y: Double?
    var type: String?
    
    init(json: NSDictionary) {
        self.lightID = json["lightID"] as? Int
        self.lightName = json["lightName"] as? String
        self.onoff = json["onoff"] as? String
        self.brightness = json["brightness"] as? Int
        self.x = json["x"] as? Double
        self.y = json["y"] as? Double
        self.type = json["type"] as? String
    }
}


