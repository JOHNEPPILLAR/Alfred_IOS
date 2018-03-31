//
//  SettingsMotionSensorLights.swift
//
//  Created by John Pillar on 31/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class SettingsMotionSensorLights: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let brightness = "brightness"
    static let lightID = "lightID"
  }

  // MARK: Properties
  public var brightness: Int?
  public var lightID: Int?

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
    brightness = json[SerializationKeys.brightness].int
    lightID = json[SerializationKeys.lightID].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = brightness { dictionary[SerializationKeys.brightness] = value }
    if let value = lightID { dictionary[SerializationKeys.lightID] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.brightness = aDecoder.decodeObject(forKey: SerializationKeys.brightness) as? Int
    self.lightID = aDecoder.decodeObject(forKey: SerializationKeys.lightID) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(brightness, forKey: SerializationKeys.brightness)
    aCoder.encode(lightID, forKey: SerializationKeys.lightID)
  }

}
