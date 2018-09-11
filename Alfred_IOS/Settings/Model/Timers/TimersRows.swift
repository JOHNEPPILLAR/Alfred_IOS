//
//  TimersRows.swift
//
//  Created by John Pillar on 08/09/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class TimersRows: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let aiOverride = "ai_override"
    static let name = "name"
    static let hour = "hour"
    static let id = "id"
    static let active = "active"
    static let minute = "minute"
  }

  // MARK: Properties
  public var aiOverride: Bool? = false
  public var name: String?
  public var hour: Int?
  public var id: Int?
  public var active: Bool? = false
  public var minute: Int?

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
    aiOverride = json[SerializationKeys.aiOverride].boolValue
    name = json[SerializationKeys.name].string
    hour = json[SerializationKeys.hour].int
    id = json[SerializationKeys.id].int
    active = json[SerializationKeys.active].boolValue
    minute = json[SerializationKeys.minute].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    dictionary[SerializationKeys.aiOverride] = aiOverride
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = hour { dictionary[SerializationKeys.hour] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    dictionary[SerializationKeys.active] = active
    if let value = minute { dictionary[SerializationKeys.minute] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.aiOverride = aDecoder.decodeBool(forKey: SerializationKeys.aiOverride)
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.hour = aDecoder.decodeObject(forKey: SerializationKeys.hour) as? Int
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.active = aDecoder.decodeBool(forKey: SerializationKeys.active)
    self.minute = aDecoder.decodeObject(forKey: SerializationKeys.minute) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(aiOverride, forKey: SerializationKeys.aiOverride)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(hour, forKey: SerializationKeys.hour)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(active, forKey: SerializationKeys.active)
    aCoder.encode(minute, forKey: SerializationKeys.minute)
  }

}
