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
    static let type = "type"
    static let light_timers_id = "light_timers_id"
    static let light_group_number = "light_group_number"
    static let brightness = "brightness"
    static let scene = "scene"
    static let color_loop = "color_loop"
  }

  // MARK: Properties
  public var aiOverride: Bool? = false
  public var name: String?
  public var hour: Int?
  public var id: Int?
  public var active: Bool? = false
  public var minute: Int?
  public var type: Int?
  public var light_timers_id: Int?
  public var light_group_number: Int?
  public var brightness: Int?
  public var scene: Int?
  public var color_loop: Bool? = false

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
    type = json[SerializationKeys.type].int
    light_timers_id = json[SerializationKeys.light_timers_id].int
    light_group_number = json[SerializationKeys.light_group_number].int
    brightness = json[SerializationKeys.brightness].int
    scene = json[SerializationKeys.scene].int
    color_loop = json[SerializationKeys.color_loop].boolValue
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
    if let value = type { dictionary[SerializationKeys.type] = value }
    if let value = light_timers_id { dictionary[SerializationKeys.light_timers_id] = value }
    if let value = light_group_number { dictionary[SerializationKeys.light_group_number] = value }
    if let value = brightness { dictionary[SerializationKeys.brightness] = value }
    if let value = scene { dictionary[SerializationKeys.scene] = value }
    dictionary[SerializationKeys.color_loop] = color_loop
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
    self.type = aDecoder.decodeObject(forKey: SerializationKeys.type) as? Int
    self.light_timers_id = aDecoder.decodeObject(forKey: SerializationKeys.light_timers_id) as? Int
    self.light_group_number = aDecoder.decodeObject(forKey: SerializationKeys.light_group_number) as? Int
    self.brightness = aDecoder.decodeObject(forKey: SerializationKeys.brightness) as? Int
    self.scene = aDecoder.decodeObject(forKey: SerializationKeys.scene) as? Int
    self.color_loop = aDecoder.decodeBool(forKey: SerializationKeys.color_loop)
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(aiOverride, forKey: SerializationKeys.aiOverride)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(hour, forKey: SerializationKeys.hour)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(active, forKey: SerializationKeys.active)
    aCoder.encode(minute, forKey: SerializationKeys.minute)
    aCoder.encode(type, forKey: SerializationKeys.type)
    aCoder.encode(light_timers_id, forKey: SerializationKeys.light_timers_id)
    aCoder.encode(light_group_number, forKey: SerializationKeys.light_group_number)
    aCoder.encode(brightness, forKey: SerializationKeys.brightness)
    aCoder.encode(scene, forKey: SerializationKeys.scene)
    aCoder.encode(color_loop, forKey: SerializationKeys.color_loop)
  }

}
