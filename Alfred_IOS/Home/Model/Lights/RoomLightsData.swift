//
//  RoomLightsData.swift
//
//  Created by John Pillar on 25/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class RoomLightsData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let state = "state"
    static let action = "action"
    static let attributes = "attributes"
  }

  // MARK: Properties
  public var state: RoomLightsState?
  public var action: RoomLightsAction?
  public var attributes: RoomLightsAttributes?

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
    action = RoomLightsAction(json: json[SerializationKeys.action])
    attributes = RoomLightsAttributes(json: json[SerializationKeys.attributes])
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = state { dictionary[SerializationKeys.state] = value.dictionaryRepresentation() }
    if let value = action { dictionary[SerializationKeys.action] = value.dictionaryRepresentation() }
    if let value = attributes { dictionary[SerializationKeys.attributes] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.state = aDecoder.decodeObject(forKey: SerializationKeys.state) as? RoomLightsState
    self.action = aDecoder.decodeObject(forKey: SerializationKeys.action) as? RoomLightsAction
    self.attributes = aDecoder.decodeObject(forKey: SerializationKeys.attributes) as? RoomLightsAttributes
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(state, forKey: SerializationKeys.state)
    aCoder.encode(action, forKey: SerializationKeys.action)
    aCoder.encode(attributes, forKey: SerializationKeys.attributes)
  }

}
