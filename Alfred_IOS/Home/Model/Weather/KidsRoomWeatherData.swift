//
//  InsideWeatherData.swift
//
//  Created by John Pillar on 11/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class InsideWeatherData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let kidsRoomCO2 = "KidsRoomCO2"
    static let kidsRoomTemperature = "KidsRoomTemperature"
  }

  // MARK: Properties
  public var kidsRoomCO2: Int?
  public var kidsRoomTemperature: Int?

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
    kidsRoomCO2 = json[SerializationKeys.kidsRoomCO2].int
    kidsRoomTemperature = json[SerializationKeys.kidsRoomTemperature].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = kidsRoomCO2 { dictionary[SerializationKeys.kidsRoomCO2] = value }
    if let value = kidsRoomTemperature { dictionary[SerializationKeys.kidsRoomTemperature] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.kidsRoomCO2 = aDecoder.decodeObject(forKey: SerializationKeys.kidsRoomCO2) as? Int
    self.kidsRoomTemperature = aDecoder.decodeObject(forKey: SerializationKeys.kidsRoomTemperature) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(kidsRoomCO2, forKey: SerializationKeys.kidsRoomCO2)
    aCoder.encode(kidsRoomTemperature, forKey: SerializationKeys.kidsRoomTemperature)
  }

}
