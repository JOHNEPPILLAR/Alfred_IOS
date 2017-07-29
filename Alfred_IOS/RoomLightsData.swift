//
//  RoomLightsData.swift
//
//  Created by John Pillar on 29/07/2017
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class RoomLightsData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let state = "state"
    static let recycle = "recycle"
    static let action = "action"
    static let classProperty = "class"
    static let id = "id"
    static let name = "name"
    static let lights = "lights"
    static let type = "type"
  }

  // MARK: Properties
  public var state: RoomLightsState?
  public var recycle: Bool? = false
  public var action: RoomLightsAction?
  public var classProperty: String?
  public var id: String?
  public var name: String?
  public var lights: [String]?
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
    state = RoomLightsState(json: json[SerializationKeys.state])
    recycle = json[SerializationKeys.recycle].boolValue
    action = RoomLightsAction(json: json[SerializationKeys.action])
    classProperty = json[SerializationKeys.classProperty].string
    id = json[SerializationKeys.id].string
    name = json[SerializationKeys.name].string
    if let items = json[SerializationKeys.lights].array { lights = items.map { $0.stringValue } }
    type = json[SerializationKeys.type].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = state { dictionary[SerializationKeys.state] = value.dictionaryRepresentation() }
    dictionary[SerializationKeys.recycle] = recycle
    if let value = action { dictionary[SerializationKeys.action] = value.dictionaryRepresentation() }
    if let value = classProperty { dictionary[SerializationKeys.classProperty] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = lights { dictionary[SerializationKeys.lights] = value }
    if let value = type { dictionary[SerializationKeys.type] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.state = aDecoder.decodeObject(forKey: SerializationKeys.state) as? RoomLightsState
    self.recycle = aDecoder.decodeBool(forKey: SerializationKeys.recycle)
    self.action = aDecoder.decodeObject(forKey: SerializationKeys.action) as? RoomLightsAction
    self.classProperty = aDecoder.decodeObject(forKey: SerializationKeys.classProperty) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.lights = aDecoder.decodeObject(forKey: SerializationKeys.lights) as? [String]
    self.type = aDecoder.decodeObject(forKey: SerializationKeys.type) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(state, forKey: SerializationKeys.state)
    aCoder.encode(recycle, forKey: SerializationKeys.recycle)
    aCoder.encode(action, forKey: SerializationKeys.action)
    aCoder.encode(classProperty, forKey: SerializationKeys.classProperty)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(lights, forKey: SerializationKeys.lights)
    aCoder.encode(type, forKey: SerializationKeys.type)
  }

}
