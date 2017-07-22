//
//  Evening.swift
//  Alfred_IOS
//
//  Created by John Pillar on 21/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Evening: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let offsetMin = "offset_min"
        static let offsetHr = "offset_hr"
        static let offHr = "off_hr"
        static let offMin = "off_min"
        static let lights = "lights"
    }
    
    // MARK: Properties
    public var offsetMin: Int?
    public var offsetHr: Int?
    public var offHr: Int?
    public var offMin: Int?
    public var lights: [Lights]?
    
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
        offsetMin = json[SerializationKeys.offsetMin].int
        offsetHr = json[SerializationKeys.offsetHr].int
        offHr = json[SerializationKeys.offHr].int
        offMin = json[SerializationKeys.offMin].int
        if let items = json[SerializationKeys.lights].array { lights = items.map { Lights(json: $0) } }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = offsetMin { dictionary[SerializationKeys.offsetMin] = value }
        if let value = offsetHr { dictionary[SerializationKeys.offsetHr] = value }
        if let value = offHr { dictionary[SerializationKeys.offHr] = value }
        if let value = offMin { dictionary[SerializationKeys.offMin] = value }
        if let value = lights { dictionary[SerializationKeys.lights] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.offsetMin = aDecoder.decodeObject(forKey: SerializationKeys.offsetMin) as? Int
        self.offsetHr = aDecoder.decodeObject(forKey: SerializationKeys.offsetHr) as? Int
        self.offHr = aDecoder.decodeObject(forKey: SerializationKeys.offHr) as? Int
        self.offMin = aDecoder.decodeObject(forKey: SerializationKeys.offMin) as? Int
        self.lights = aDecoder.decodeObject(forKey: SerializationKeys.lights) as? [Lights]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(offsetMin, forKey: SerializationKeys.offsetMin)
        aCoder.encode(offsetHr, forKey: SerializationKeys.offsetHr)
        aCoder.encode(offHr, forKey: SerializationKeys.offHr)
        aCoder.encode(offMin, forKey: SerializationKeys.offMin)
        aCoder.encode(lights, forKey: SerializationKeys.lights)
    }
}
