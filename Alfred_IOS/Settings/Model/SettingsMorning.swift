//
//  SettingsMorning.swift
//
//  Created by John Pillar on 31/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class SettingsMorning: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let masterOn = "master_on"
    static let lights = "lights"
    static let onMin = "on_min"
    static let onHr = "on_hr"
  }

  // MARK: Properties
  public var masterOn: String?
  public var lights: [SettingsLights]?
  public var onMin: Int?
  public var onHr: Int?

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
    masterOn = json[SerializationKeys.masterOn].string
    if let items = json[SerializationKeys.lights].array { lights = items.map { SettingsLights(json: $0) } }
    onMin = json[SerializationKeys.onMin].int
    onHr = json[SerializationKeys.onHr].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = masterOn { dictionary[SerializationKeys.masterOn] = value }
    if let value = lights { dictionary[SerializationKeys.lights] = value.map { $0.dictionaryRepresentation() } }
    if let value = onMin { dictionary[SerializationKeys.onMin] = value }
    if let value = onHr { dictionary[SerializationKeys.onHr] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.masterOn = aDecoder.decodeObject(forKey: SerializationKeys.masterOn) as? String
    self.lights = aDecoder.decodeObject(forKey: SerializationKeys.lights) as? [SettingsLights]
    self.onMin = aDecoder.decodeObject(forKey: SerializationKeys.onMin) as? Int
    self.onHr = aDecoder.decodeObject(forKey: SerializationKeys.onHr) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(masterOn, forKey: SerializationKeys.masterOn)
    aCoder.encode(lights, forKey: SerializationKeys.lights)
    aCoder.encode(onMin, forKey: SerializationKeys.onMin)
    aCoder.encode(onHr, forKey: SerializationKeys.onHr)
  }

}
