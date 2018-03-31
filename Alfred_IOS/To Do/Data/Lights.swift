//
//  Lights.swift
//  Alfred_IOS
//
//  Created by John Pillar on 21/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Lights: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let lightID = "lightID"
        static let lightName = "lightName"
        static let brightness = "brightness"
        static let onoff = "onoff"
        static let type = "type"
        static let xy = "xy"
        static let ct = "ct"
        static let colormode = "colormode"
    }
    
    // MARK: Properties
    public var lightID: Int?
    public var lightName: String?
    public var brightness: Int?
    public var onoff: String?
    public var type: String?
    public var xy: [Float]?
    public var ct: Int?
    public var colormode: String?

    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public required init(json: JSON) {
        lightID = json[SerializationKeys.lightID].int
        lightName = json[SerializationKeys.lightName].string
        brightness = json[SerializationKeys.brightness].int
        if brightness == nil { brightness = 0 }
        onoff = json[SerializationKeys.onoff].string
        if onoff == nil { onoff = "off" }
        type = json[SerializationKeys.type].string
        if let items = json[SerializationKeys.xy].array { xy = items.map { $0.floatValue } }
        ct = json[SerializationKeys.ct].int
        colormode = json[SerializationKeys.colormode].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = lightID { dictionary[SerializationKeys.lightID] = value }
        if let value = lightName { dictionary[SerializationKeys.lightName] = value }
        if let value = brightness { dictionary[SerializationKeys.brightness] = value }
        if let value = onoff { dictionary[SerializationKeys.onoff] = value }
        if let value = type { dictionary[SerializationKeys.type] = value }
        if let value = xy { dictionary[SerializationKeys.xy] = value }
        if let value = ct { dictionary[SerializationKeys.ct] = value }
        if let value = colormode { dictionary[SerializationKeys.colormode] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.lightID = aDecoder.decodeObject(forKey: SerializationKeys.lightID) as? Int
        self.lightName = aDecoder.decodeObject(forKey: SerializationKeys.lightName) as? String
        self.brightness = aDecoder.decodeObject(forKey: SerializationKeys.brightness) as? Int
        self.onoff = aDecoder.decodeObject(forKey: SerializationKeys.onoff) as? String
        self.type = aDecoder.decodeObject(forKey: SerializationKeys.type) as? String
        self.xy = aDecoder.decodeObject(forKey: SerializationKeys.xy) as? [Float]
        self.ct = aDecoder.decodeObject(forKey: SerializationKeys.ct) as? Int
        self.colormode = aDecoder.decodeObject(forKey: SerializationKeys.colormode) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(lightID, forKey: SerializationKeys.lightID)
        aCoder.encode(lightName, forKey: SerializationKeys.lightName)
        aCoder.encode(brightness, forKey: SerializationKeys.brightness)
        aCoder.encode(onoff, forKey: SerializationKeys.onoff)
        aCoder.encode(type, forKey: SerializationKeys.type)
        aCoder.encode(xy, forKey: SerializationKeys.xy)
        aCoder.encode(ct, forKey: SerializationKeys.ct)
        aCoder.encode(colormode, forKey: SerializationKeys.colormode)
    }
}
