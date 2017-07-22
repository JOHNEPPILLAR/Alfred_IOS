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
    }
    
    // MARK: Properties
    public var lightID: Int?
    public var lightName: String?
    public var brightness: Int?
    public var onoff: String?
    public var x: Int?
    public var y: Int?
    public var type: String?
    
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
        onoff = json[SerializationKeys.onoff].string
        x = json[SerializationKeys.x].int
        y = json[SerializationKeys.y].int
        type = json[SerializationKeys.type].string
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
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.lightID = aDecoder.decodeObject(forKey: SerializationKeys.lightID) as? Int
        self.lightName = aDecoder.decodeObject(forKey: SerializationKeys.lightName) as? String
        self.brightness = aDecoder.decodeObject(forKey: SerializationKeys.brightness) as? Int
        self.onoff = aDecoder.decodeObject(forKey: SerializationKeys.onoff) as? String
        self.x = aDecoder.decodeObject(forKey: SerializationKeys.x) as? Int
        self.y = aDecoder.decodeObject(forKey: SerializationKeys.y) as? Int
        self.type = aDecoder.decodeObject(forKey: SerializationKeys.type) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(lightID, forKey: SerializationKeys.lightID)
        aCoder.encode(lightName, forKey: SerializationKeys.lightName)
        aCoder.encode(brightness, forKey: SerializationKeys.brightness)
        aCoder.encode(onoff, forKey: SerializationKeys.onoff)
        aCoder.encode(x, forKey: SerializationKeys.x)
        aCoder.encode(y, forKey: SerializationKeys.y)
        aCoder.encode(type, forKey: SerializationKeys.type)
    }
    
}
