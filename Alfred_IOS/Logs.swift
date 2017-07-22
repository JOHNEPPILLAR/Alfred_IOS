//
//  LogFile.swift
//  Alfred_IOS
//
//  Created by John Pillar on 21/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Logs: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let message = "message"
        static let timestamp = "timestamp"
        static let level = "level"
    }
    
    // MARK: Properties
    public var message: String?
    public var timestamp: String?
    public var level: String?
    
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
        message = json[SerializationKeys.message].string
        timestamp = json[SerializationKeys.timestamp].string
        level = json[SerializationKeys.level].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = message { dictionary[SerializationKeys.message] = value }
        if let value = timestamp { dictionary[SerializationKeys.timestamp] = value }
        if let value = level { dictionary[SerializationKeys.level] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.message = aDecoder.decodeObject(forKey: SerializationKeys.message) as? String
        self.timestamp = aDecoder.decodeObject(forKey: SerializationKeys.timestamp) as? String
        self.level = aDecoder.decodeObject(forKey: SerializationKeys.level) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(message, forKey: SerializationKeys.message)
        aCoder.encode(timestamp, forKey: SerializationKeys.timestamp)
        aCoder.encode(level, forKey: SerializationKeys.level)
    }
    
}
