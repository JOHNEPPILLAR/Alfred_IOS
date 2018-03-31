//
//  SettingsMorning.swift
//
//  Created by John Pillar on 31/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class SettingsOffMorning: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let masterOn = "master_on"
    static let offHr = "off_hr"
    static let offMin = "off_min"
  }

  // MARK: Properties
  public var masterOn: String?
  public var offHr: Int?
  public var offMin: Int?

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
    masterOn = json[SerializationKeys.masterOn].string
    offHr = json[SerializationKeys.offHr].int
    offMin = json[SerializationKeys.offMin].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = masterOn { dictionary[SerializationKeys.masterOn] = value }
    if let value = offHr { dictionary[SerializationKeys.offHr] = value }
    if let value = offMin { dictionary[SerializationKeys.offMin] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.masterOn = aDecoder.decodeObject(forKey: SerializationKeys.masterOn) as? String
    self.offHr = aDecoder.decodeObject(forKey: SerializationKeys.offHr) as? Int
    self.offMin = aDecoder.decodeObject(forKey: SerializationKeys.offMin) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(masterOn, forKey: SerializationKeys.masterOn)
    aCoder.encode(offHr, forKey: SerializationKeys.offHr)
    aCoder.encode(offMin, forKey: SerializationKeys.offMin)
  }

}
