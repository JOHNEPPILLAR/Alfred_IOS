//
//  RoomLightsAttributesAttributes.swift
//
//  Created by John Pillar on 25/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class RoomLightsAttributesAttributes: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let classProperty = "class"
    static let lights = "lights"
    static let id = "id"
    static let type = "type"
  }

  // MARK: Properties
  public var name: String?
  public var classProperty: String?
  public var lights: [String]?
  public var id: String?
  public var type: String?

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
    name = json[SerializationKeys.name].string
    classProperty = json[SerializationKeys.classProperty].string
    if let items = json[SerializationKeys.lights].array { lights = items.map { $0.stringValue } }
    id = json[SerializationKeys.id].string
    type = json[SerializationKeys.type].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = classProperty { dictionary[SerializationKeys.classProperty] = value }
    if let value = lights { dictionary[SerializationKeys.lights] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = type { dictionary[SerializationKeys.type] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.classProperty = aDecoder.decodeObject(forKey: SerializationKeys.classProperty) as? String
    self.lights = aDecoder.decodeObject(forKey: SerializationKeys.lights) as? [String]
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
    self.type = aDecoder.decodeObject(forKey: SerializationKeys.type) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(classProperty, forKey: SerializationKeys.classProperty)
    aCoder.encode(lights, forKey: SerializationKeys.lights)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(type, forKey: SerializationKeys.type)
  }

}
