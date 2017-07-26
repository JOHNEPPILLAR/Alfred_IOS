//
//  Morning.swift
//  Alfred_IOS
//
//  Created by John Pillar on 26/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Morning: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let onMin = "on_min"
        static let onHr = "on_hr"
        static let offHr = "off_hr"
        static let offMin = "off_min"
        static let lights = "lights"
    }
    
    // MARK: Properties
    public var onMin: Int?
    public var onHr: Int?
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
        onMin = json[SerializationKeys.onMin].int
        onHr = json[SerializationKeys.onHr].int
        offHr = json[SerializationKeys.offHr].int
        offMin = json[SerializationKeys.offMin].int
        if let items = json[SerializationKeys.lights].array { lights = items.map { Lights(json: $0) } }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = onMin { dictionary[SerializationKeys.onMin] = value }
        if let value = onHr { dictionary[SerializationKeys.onHr] = value }
        if let value = offHr { dictionary[SerializationKeys.offHr] = value }
        if let value = offMin { dictionary[SerializationKeys.offMin] = value }
        if let value = lights { dictionary[SerializationKeys.lights] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.onMin = aDecoder.decodeObject(forKey: SerializationKeys.onMin) as? Int
        self.onHr = aDecoder.decodeObject(forKey: SerializationKeys.onHr) as? Int
        self.offHr = aDecoder.decodeObject(forKey: SerializationKeys.offHr) as? Int
        self.offMin = aDecoder.decodeObject(forKey: SerializationKeys.offMin) as? Int
        self.lights = aDecoder.decodeObject(forKey: SerializationKeys.lights) as? [Lights]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(onMin, forKey: SerializationKeys.onMin)
        aCoder.encode(onHr, forKey: SerializationKeys.onHr)
        aCoder.encode(offHr, forKey: SerializationKeys.offHr)
        aCoder.encode(offMin, forKey: SerializationKeys.offMin)
        aCoder.encode(lights, forKey: SerializationKeys.lights)
    }
}
