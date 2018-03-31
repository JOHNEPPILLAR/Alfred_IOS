//
//  SettingsData.swift
//
//  Created by John Pillar on 31/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class SettingsData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let motionSensorLights = "motionSensorLights"
    static let off = "off"
    static let on = "on"
  }

  // MARK: Properties
  public var motionSensorLights: [SettingsMotionSensorLights]?
  public var off: SettingsOff?
  public var on: SettingsOn?

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
    if let items = json[SerializationKeys.motionSensorLights].array { motionSensorLights = items.map { SettingsMotionSensorLights(json: $0) } }
    off = SettingsOff(json: json[SerializationKeys.off])
    on = SettingsOn(json: json[SerializationKeys.on])
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = motionSensorLights { dictionary[SerializationKeys.motionSensorLights] = value.map { $0.dictionaryRepresentation() } }
    if let value = off { dictionary[SerializationKeys.off] = value.dictionaryRepresentation() }
    if let value = on { dictionary[SerializationKeys.on] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.motionSensorLights = aDecoder.decodeObject(forKey: SerializationKeys.motionSensorLights) as? [SettingsMotionSensorLights]
    self.off = aDecoder.decodeObject(forKey: SerializationKeys.off) as? SettingsOff
    self.on = aDecoder.decodeObject(forKey: SerializationKeys.on) as? SettingsOn
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(motionSensorLights, forKey: SerializationKeys.motionSensorLights)
    aCoder.encode(off, forKey: SerializationKeys.off)
    aCoder.encode(on, forKey: SerializationKeys.on)
  }

}
