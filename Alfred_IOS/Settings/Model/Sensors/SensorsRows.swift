//
//  SensorsRows.swift
//
//  Created by John Pillar on 30/09/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class SensorsRows: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let startTime = "start_time"
    static let id = "id"
    static let lightAction = "light_action"
    static let endTime = "end_time"
    static let scene = "scene"
    static let sensorId = "sensor_id"
    static let lightGroupNumber = "light_group_number"
    static let active = "active"
    static let brightness = "brightness"
    static let turnOff = "turn_off"
  }

  // MARK: Properties
  public var startTime: String?
  public var id: Int?
  public var lightAction: String?
  public var endTime: String?
  public var scene: Int?
  public var sensorId: Int?
  public var lightGroupNumber: Int?
  public var active: Bool? = false
  public var brightness: Int?
  public var turnOff: String?

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
    startTime = json[SerializationKeys.startTime].string
    id = json[SerializationKeys.id].int
    lightAction = json[SerializationKeys.lightAction].string
    endTime = json[SerializationKeys.endTime].string
    scene = json[SerializationKeys.scene].int
    sensorId = json[SerializationKeys.sensorId].int
    lightGroupNumber = json[SerializationKeys.lightGroupNumber].int
    active = json[SerializationKeys.active].boolValue
    brightness = json[SerializationKeys.brightness].int
    turnOff = json[SerializationKeys.turnOff].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = startTime { dictionary[SerializationKeys.startTime] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = lightAction { dictionary[SerializationKeys.lightAction] = value }
    if let value = endTime { dictionary[SerializationKeys.endTime] = value }
    if let value = scene { dictionary[SerializationKeys.scene] = value }
    if let value = sensorId { dictionary[SerializationKeys.sensorId] = value }
    if let value = lightGroupNumber { dictionary[SerializationKeys.lightGroupNumber] = value }
    dictionary[SerializationKeys.active] = active
    if let value = brightness { dictionary[SerializationKeys.brightness] = value }
    if let value = turnOff { dictionary[SerializationKeys.turnOff] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.startTime = aDecoder.decodeObject(forKey: SerializationKeys.startTime) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.lightAction = aDecoder.decodeObject(forKey: SerializationKeys.lightAction) as? String
    self.endTime = aDecoder.decodeObject(forKey: SerializationKeys.endTime) as? String
    self.scene = aDecoder.decodeObject(forKey: SerializationKeys.scene) as? Int
    self.sensorId = aDecoder.decodeObject(forKey: SerializationKeys.sensorId) as? Int
    self.lightGroupNumber = aDecoder.decodeObject(forKey: SerializationKeys.lightGroupNumber) as? Int
    self.active = aDecoder.decodeBool(forKey: SerializationKeys.active)
    self.brightness = aDecoder.decodeObject(forKey: SerializationKeys.brightness) as? Int
    self.turnOff = aDecoder.decodeObject(forKey: SerializationKeys.turnOff) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(startTime, forKey: SerializationKeys.startTime)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(lightAction, forKey: SerializationKeys.lightAction)
    aCoder.encode(endTime, forKey: SerializationKeys.endTime)
    aCoder.encode(scene, forKey: SerializationKeys.scene)
    aCoder.encode(sensorId, forKey: SerializationKeys.sensorId)
    aCoder.encode(lightGroupNumber, forKey: SerializationKeys.lightGroupNumber)
    aCoder.encode(active, forKey: SerializationKeys.active)
    aCoder.encode(brightness, forKey: SerializationKeys.brightness)
    aCoder.encode(turnOff, forKey: SerializationKeys.turnOff)
  }

}
