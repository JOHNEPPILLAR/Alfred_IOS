//
//  SettingsLights.swift
//
//  Created by John Pillar on 31/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class SettingsLights: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let ct = "ct"
    static let colormode = "colormode"
    static let lightName = "lightName"
    static let lightID = "lightID"
    static let type = "type"
    static let brightness = "brightness"
    static let onoff = "onoff"
    static let xy = "xy"
  }

  // MARK: Properties
  public var ct: Int?
  public var colormode: String?
  public var lightName: String?
  public var lightID: Int?
  public var type: String?
  public var brightness: Int?
  public var onoff: String?
  public var xy: [Float]?

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
    ct = json[SerializationKeys.ct].int
    colormode = json[SerializationKeys.colormode].string
    lightName = json[SerializationKeys.lightName].string
    lightID = json[SerializationKeys.lightID].int
    type = json[SerializationKeys.type].string
    brightness = json[SerializationKeys.brightness].int
    onoff = json[SerializationKeys.onoff].string
    if let items = json[SerializationKeys.xy].array { xy = items.map { $0.floatValue } }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = ct { dictionary[SerializationKeys.ct] = value }
    if let value = colormode { dictionary[SerializationKeys.colormode] = value }
    if let value = lightName { dictionary[SerializationKeys.lightName] = value }
    if let value = lightID { dictionary[SerializationKeys.lightID] = value }
    if let value = type { dictionary[SerializationKeys.type] = value }
    if let value = brightness { dictionary[SerializationKeys.brightness] = value }
    if let value = onoff { dictionary[SerializationKeys.onoff] = value }
    if let value = xy { dictionary[SerializationKeys.xy] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.ct = aDecoder.decodeObject(forKey: SerializationKeys.ct) as? Int
    self.colormode = aDecoder.decodeObject(forKey: SerializationKeys.colormode) as? String
    self.lightName = aDecoder.decodeObject(forKey: SerializationKeys.lightName) as? String
    self.lightID = aDecoder.decodeObject(forKey: SerializationKeys.lightID) as? Int
    self.type = aDecoder.decodeObject(forKey: SerializationKeys.type) as? String
    self.brightness = aDecoder.decodeObject(forKey: SerializationKeys.brightness) as? Int
    self.onoff = aDecoder.decodeObject(forKey: SerializationKeys.onoff) as? String
    self.xy = aDecoder.decodeObject(forKey: SerializationKeys.xy) as? [Float]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(ct, forKey: SerializationKeys.ct)
    aCoder.encode(colormode, forKey: SerializationKeys.colormode)
    aCoder.encode(lightName, forKey: SerializationKeys.lightName)
    aCoder.encode(lightID, forKey: SerializationKeys.lightID)
    aCoder.encode(type, forKey: SerializationKeys.type)
    aCoder.encode(brightness, forKey: SerializationKeys.brightness)
    aCoder.encode(onoff, forKey: SerializationKeys.onoff)
    aCoder.encode(xy, forKey: SerializationKeys.xy)
  }

}
