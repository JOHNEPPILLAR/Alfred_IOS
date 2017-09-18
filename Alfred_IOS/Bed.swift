//
//  Bed.swift
//  Alfred_IOS
//
//  Created by John Pillar on 17/09/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Bed: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let on = "on"
        static let onMin = "onMin"
        static let onHR = "onHR"
        static let offMin = "offMin"
        static let side = "side"
        static let trigger = "trigger"
        static let useDI = "useDI"
        static let offHR = "offHR"
        static let bedTemp = "bedTemp"
    }
    
    // MARK: Properties
    public var on: Bool? = false
    public var onMin: Int?
    public var onHR: Int?
    public var offMin: Int?
    public var side: String?
    public var trigger: Int?
    public var useDI: Bool? = false
    public var offHR: Int?
    public var bedTemp: Int?
    
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
        on = json[SerializationKeys.on].boolValue
        onMin = json[SerializationKeys.onMin].int
        onHR = json[SerializationKeys.onHR].int
        offMin = json[SerializationKeys.offMin].int
        side = json[SerializationKeys.side].string
        trigger = json[SerializationKeys.trigger].int
        useDI = json[SerializationKeys.useDI].boolValue
        offHR = json[SerializationKeys.offHR].int
        bedTemp = json[SerializationKeys.bedTemp].int
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[SerializationKeys.on] = on
        if let value = onMin { dictionary[SerializationKeys.onMin] = value }
        if let value = onHR { dictionary[SerializationKeys.onHR] = value }
        if let value = offMin { dictionary[SerializationKeys.offMin] = value }
        if let value = side { dictionary[SerializationKeys.side] = value }
        if let value = trigger { dictionary[SerializationKeys.trigger] = value }
        dictionary[SerializationKeys.useDI] = useDI
        if let value = offHR { dictionary[SerializationKeys.offHR] = value }
        if let value = bedTemp { dictionary[SerializationKeys.bedTemp] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.on = aDecoder.decodeBool(forKey: SerializationKeys.on)
        self.onMin = aDecoder.decodeObject(forKey: SerializationKeys.onMin) as? Int
        self.onHR = aDecoder.decodeObject(forKey: SerializationKeys.onHR) as? Int
        self.offMin = aDecoder.decodeObject(forKey: SerializationKeys.offMin) as? Int
        self.side = aDecoder.decodeObject(forKey: SerializationKeys.side) as? String
        self.trigger = aDecoder.decodeObject(forKey: SerializationKeys.trigger) as? Int
        self.useDI = aDecoder.decodeBool(forKey: SerializationKeys.useDI)
        self.offHR = aDecoder.decodeObject(forKey: SerializationKeys.offHR) as? Int
        self.bedTemp = aDecoder.decodeObject(forKey: SerializationKeys.bedTemp) as? Int
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(on, forKey: SerializationKeys.on)
        aCoder.encode(onMin, forKey: SerializationKeys.onMin)
        aCoder.encode(onHR, forKey: SerializationKeys.onHR)
        aCoder.encode(offMin, forKey: SerializationKeys.offMin)
        aCoder.encode(side, forKey: SerializationKeys.side)
        aCoder.encode(trigger, forKey: SerializationKeys.trigger)
        aCoder.encode(useDI, forKey: SerializationKeys.useDI)
        aCoder.encode(offHR, forKey: SerializationKeys.offHR)
        aCoder.encode(bedTemp, forKey: SerializationKeys.bedTemp)
    }    
}
