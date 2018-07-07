//
//  RoomLightsState.swift
//
//  Created by John Pillar on 25/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class RoomLightsState: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let attributes = "attributes"
    static let changed = "changed"
  }

  // MARK: Properties
  public var attributes: RoomLightsStateAttributes?
  public var changed: RoomLightsChanged?

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
    attributes = RoomLightsStateAttributes(json: json[SerializationKeys.attributes])
    changed = RoomLightsChanged(json: json[SerializationKeys.changed])
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = attributes { dictionary[SerializationKeys.attributes] = value.dictionaryRepresentation() }
    if let value = changed { dictionary[SerializationKeys.changed] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.attributes = aDecoder.decodeObject(forKey: SerializationKeys.attributes) as? RoomLightsStateAttributes
    self.changed = aDecoder.decodeObject(forKey: SerializationKeys.changed) as? RoomLightsChanged
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(attributes, forKey: SerializationKeys.attributes)
    aCoder.encode(changed, forKey: SerializationKeys.changed)
  }

}
