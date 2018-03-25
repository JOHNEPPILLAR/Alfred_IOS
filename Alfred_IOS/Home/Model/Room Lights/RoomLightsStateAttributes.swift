//
//  RoomLightsStateAttributes.swift
//
//  Created by John Pillar on 25/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class RoomLightsStateAttributes: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let allOn = "all_on"
    static let anyOn = "any_on"
  }

  // MARK: Properties
  public var allOn: Bool? = false
  public var anyOn: Bool? = false

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
    allOn = json[SerializationKeys.allOn].boolValue
    anyOn = json[SerializationKeys.anyOn].boolValue
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    dictionary[SerializationKeys.allOn] = allOn
    dictionary[SerializationKeys.anyOn] = anyOn
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.allOn = aDecoder.decodeBool(forKey: SerializationKeys.allOn)
    self.anyOn = aDecoder.decodeBool(forKey: SerializationKeys.anyOn)
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(allOn, forKey: SerializationKeys.allOn)
    aCoder.encode(anyOn, forKey: SerializationKeys.anyOn)
  }

}
