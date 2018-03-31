//
//  SettingsOff.swift
//
//  Created by John Pillar on 31/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class SettingsOff: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let evening = "evening"
    static let morning = "morning"
  }

  // MARK: Properties
  public var evening: SettingsOffEvening?
  public var morning: SettingsOffMorning?

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
    evening = SettingsOffEvening(json: json[SerializationKeys.evening])
    morning = SettingsOffMorning(json: json[SerializationKeys.morning])
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = evening { dictionary[SerializationKeys.evening] = value.dictionaryRepresentation() }
    if let value = morning { dictionary[SerializationKeys.morning] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.evening = aDecoder.decodeObject(forKey: SerializationKeys.evening) as? SettingsOffEvening
    self.morning = aDecoder.decodeObject(forKey: SerializationKeys.morning) as? SettingsOffMorning
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(evening, forKey: SerializationKeys.evening)
    aCoder.encode(morning, forKey: SerializationKeys.morning)
  }

}
