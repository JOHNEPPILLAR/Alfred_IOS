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
        static let x = "x"
        static let y = "y"
        static let type = "type"
        static let red = "red"
        static let green = "green"
        static let blue = "blue"
    }
    
    // MARK: Properties
    public var lightID: Int?
    public var lightName: String?
    public var brightness: Int?
    public var onoff: String?
    public var x: Double?
    public var y: Double?
    public var type: String?
    public var red: Int?
    public var green: Int?
    public var blue: Int?
    
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
        x = json[SerializationKeys.x].double
        y = json[SerializationKeys.y].double
        type = json[SerializationKeys.type].string
        red = json[SerializationKeys.red].int
        green = json[SerializationKeys.green].int
        blue = json[SerializationKeys.blue].int
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
        if let value = x { dictionary[SerializationKeys.x] = value }
        if let value = y { dictionary[SerializationKeys.y] = value }
        if let value = type { dictionary[SerializationKeys.type] = value }
        if let value = red { dictionary[SerializationKeys.red] = value }
        if let value = green { dictionary[SerializationKeys.green] = value }
        if let value = blue { dictionary[SerializationKeys.blue] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.lightID = aDecoder.decodeObject(forKey: SerializationKeys.lightID) as? Int
        self.lightName = aDecoder.decodeObject(forKey: SerializationKeys.lightName) as? String
        self.brightness = aDecoder.decodeObject(forKey: SerializationKeys.brightness) as? Int
        self.onoff = aDecoder.decodeObject(forKey: SerializationKeys.onoff) as? String
        self.x = aDecoder.decodeObject(forKey: SerializationKeys.x) as? Double
        self.y = aDecoder.decodeObject(forKey: SerializationKeys.y) as? Double
        self.type = aDecoder.decodeObject(forKey: SerializationKeys.type) as? String
        self.red = aDecoder.decodeObject(forKey: SerializationKeys.red) as? Int
        self.green = aDecoder.decodeObject(forKey: SerializationKeys.green) as? Int
        self.blue = aDecoder.decodeObject(forKey: SerializationKeys.blue) as? Int
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(lightID, forKey: SerializationKeys.lightID)
        aCoder.encode(lightName, forKey: SerializationKeys.lightName)
        aCoder.encode(brightness, forKey: SerializationKeys.brightness)
        aCoder.encode(onoff, forKey: SerializationKeys.onoff)
        aCoder.encode(x, forKey: SerializationKeys.x)
        aCoder.encode(y, forKey: SerializationKeys.y)
        aCoder.encode(type, forKey: SerializationKeys.type)
        aCoder.encode(red, forKey: SerializationKeys.red)
        aCoder.encode(green, forKey: SerializationKeys.green)
        aCoder.encode(blue, forKey: SerializationKeys.blue)
    }
    
}
