//
//  RoomLightsAction.swift
//
//  Created by John Pillar on 29/07/2017
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class RoomLightsAction: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let ct = "ct"
    static let on = "on"
    static let alert = "alert"
    static let sat = "sat"
    static let hue = "hue"
    static let bri = "bri"
    static let effect = "effect"
    static let colormode = "colormode"
    static let xy = "xy"
  }

  // MARK: Properties
  public var ct: Int?
  public var on: Bool? = false
  public var alert: String?
  public var sat: Int?
  public var hue: Int?
  public var bri: Int?
  public var effect: String?
  public var colormode: String?
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
    on = json[SerializationKeys.on].boolValue
    alert = json[SerializationKeys.alert].string
    sat = json[SerializationKeys.sat].int
    hue = json[SerializationKeys.hue].int
    bri = json[SerializationKeys.bri].int
    effect = json[SerializationKeys.effect].string
    colormode = json[SerializationKeys.colormode].string
    if let items = json[SerializationKeys.xy].array { xy = items.map { $0.floatValue } }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = ct { dictionary[SerializationKeys.ct] = value }
    dictionary[SerializationKeys.on] = on
    if let value = alert { dictionary[SerializationKeys.alert] = value }
    if let value = sat { dictionary[SerializationKeys.sat] = value }
    if let value = hue { dictionary[SerializationKeys.hue] = value }
    if let value = bri { dictionary[SerializationKeys.bri] = value }
    if let value = effect { dictionary[SerializationKeys.effect] = value }
    if let value = colormode { dictionary[SerializationKeys.colormode] = value }
    if let value = xy { dictionary[SerializationKeys.xy] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.ct = aDecoder.decodeObject(forKey: SerializationKeys.ct) as? Int
    self.on = aDecoder.decodeBool(forKey: SerializationKeys.on)
    self.alert = aDecoder.decodeObject(forKey: SerializationKeys.alert) as? String
    self.sat = aDecoder.decodeObject(forKey: SerializationKeys.sat) as? Int
    self.hue = aDecoder.decodeObject(forKey: SerializationKeys.hue) as? Int
    self.bri = aDecoder.decodeObject(forKey: SerializationKeys.bri) as? Int
    self.effect = aDecoder.decodeObject(forKey: SerializationKeys.effect) as? String
    self.colormode = aDecoder.decodeObject(forKey: SerializationKeys.colormode) as? String
    self.xy = aDecoder.decodeObject(forKey: SerializationKeys.xy) as? [Float]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(ct, forKey: SerializationKeys.ct)
    aCoder.encode(on, forKey: SerializationKeys.on)
    aCoder.encode(alert, forKey: SerializationKeys.alert)
    aCoder.encode(sat, forKey: SerializationKeys.sat)
    aCoder.encode(hue, forKey: SerializationKeys.hue)
    aCoder.encode(bri, forKey: SerializationKeys.bri)
    aCoder.encode(effect, forKey: SerializationKeys.effect)
    aCoder.encode(colormode, forKey: SerializationKeys.colormode)
    aCoder.encode(xy, forKey: SerializationKeys.xy)
  }

}
