//
//  SchedulesData.swift
//
//  Created by John Pillar on 17/05/2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class SchedulesData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let aiOverride = "ai_override"
    static let colorLoop = "color_loop"
    static let hour = "hour"
    static let id = "id"
    static let name = "name"
    static let scene = "scene"
    static let lightGroupNumber = "light_group_number"
    static let active = "active"
    static let brightness = "brightness"
    static let type = "type"
    static let minute = "minute"
  }

  // MARK: Properties
  public var aiOverride: Bool? = false
  public var colorLoop: Bool? = false
  public var hour: Int?
  public var id: Int?
  public var name: String?
  public var scene: Int?
  public var lightGroupNumber: Int?
  public var active: Bool? = false
  public var brightness: Int?
  public var type: Int?
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
    colorLoop = json[SerializationKeys.colorLoop].boolValue
    hour = json[SerializationKeys.hour].int
    id = json[SerializationKeys.id].int
    name = json[SerializationKeys.name].string
    scene = json[SerializationKeys.scene].int
    lightGroupNumber = json[SerializationKeys.lightGroupNumber].int
    active = json[SerializationKeys.active].boolValue
    brightness = json[SerializationKeys.brightness].int
    type = json[SerializationKeys.type].int
    minute = json[SerializationKeys.minute].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    dictionary[SerializationKeys.aiOverride] = aiOverride
    dictionary[SerializationKeys.colorLoop] = colorLoop
    if let value = hour { dictionary[SerializationKeys.hour] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = scene { dictionary[SerializationKeys.scene] = value }
    if let value = lightGroupNumber { dictionary[SerializationKeys.lightGroupNumber] = value }
    dictionary[SerializationKeys.active] = active
    if let value = brightness { dictionary[SerializationKeys.brightness] = value }
    if let value = type { dictionary[SerializationKeys.type] = value }
    if let value = minute { dictionary[SerializationKeys.minute] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.aiOverride = aDecoder.decodeBool(forKey: SerializationKeys.aiOverride)
    self.colorLoop = aDecoder.decodeBool(forKey: SerializationKeys.colorLoop)
    self.hour = aDecoder.decodeObject(forKey: SerializationKeys.hour) as? Int
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.scene = aDecoder.decodeObject(forKey: SerializationKeys.scene) as? Int
    self.lightGroupNumber = aDecoder.decodeObject(forKey: SerializationKeys.lightGroupNumber) as? Int
    self.active = aDecoder.decodeBool(forKey: SerializationKeys.active)
    self.brightness = aDecoder.decodeObject(forKey: SerializationKeys.brightness) as? Int
    self.type = aDecoder.decodeObject(forKey: SerializationKeys.type) as? Int
    self.minute = aDecoder.decodeObject(forKey: SerializationKeys.minute) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(aiOverride, forKey: SerializationKeys.aiOverride)
    aCoder.encode(colorLoop, forKey: SerializationKeys.colorLoop)
    aCoder.encode(hour, forKey: SerializationKeys.hour)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(scene, forKey: SerializationKeys.scene)
    aCoder.encode(lightGroupNumber, forKey: SerializationKeys.lightGroupNumber)
    aCoder.encode(active, forKey: SerializationKeys.active)
    aCoder.encode(brightness, forKey: SerializationKeys.brightness)
    aCoder.encode(type, forKey: SerializationKeys.type)
    aCoder.encode(minute, forKey: SerializationKeys.minute)
  }

}
