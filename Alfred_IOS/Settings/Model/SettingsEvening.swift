//
//  SettingsEvening.swift
//
//  Created by John Pillar on 31/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class SettingsEvening: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let offsetMin = "offset_min"
    static let masterOn = "master_on"
    static let lights = "lights"
    static let offsetHr = "offset_hr"
  }

  // MARK: Properties
  public var offsetMin: Int?
  public var masterOn: String?
  public var lights: [SettingsLights]?
  public var offsetHr: Int?

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
    masterOn = json[SerializationKeys.masterOn].string
    if let items = json[SerializationKeys.lights].array { lights = items.map { SettingsLights(json: $0) } }
    offsetHr = json[SerializationKeys.offsetHr].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = offsetMin { dictionary[SerializationKeys.offsetMin] = value }
    if let value = masterOn { dictionary[SerializationKeys.masterOn] = value }
    if let value = lights { dictionary[SerializationKeys.lights] = value.map { $0.dictionaryRepresentation() } }
    if let value = offsetHr { dictionary[SerializationKeys.offsetHr] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.offsetMin = aDecoder.decodeObject(forKey: SerializationKeys.offsetMin) as? Int
    self.masterOn = aDecoder.decodeObject(forKey: SerializationKeys.masterOn) as? String
    self.lights = aDecoder.decodeObject(forKey: SerializationKeys.lights) as? [SettingsLights]
    self.offsetHr = aDecoder.decodeObject(forKey: SerializationKeys.offsetHr) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(offsetMin, forKey: SerializationKeys.offsetMin)
    aCoder.encode(masterOn, forKey: SerializationKeys.masterOn)
    aCoder.encode(lights, forKey: SerializationKeys.lights)
    aCoder.encode(offsetHr, forKey: SerializationKeys.offsetHr)
  }

}
