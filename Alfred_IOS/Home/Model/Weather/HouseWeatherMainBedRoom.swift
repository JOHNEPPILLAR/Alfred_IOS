//
//  HouseWeatherMainBedRoom.swift
//
//  Created by John Pillar on 13/01/2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class HouseWeatherMainBedRoom: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let battery = "Battery"
    static let temperature = "Temperature"
    static let airQuality = "AirQuality"
    static let humidity = "Humidity"
  }

  // MARK: Properties
  public var battery: Int?
  public var temperature: Int?
  public var airQuality: Int?
  public var humidity: Int?

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
    battery = json[SerializationKeys.battery].int
    temperature = json[SerializationKeys.temperature].int
    airQuality = json[SerializationKeys.airQuality].int
    humidity = json[SerializationKeys.humidity].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = battery { dictionary[SerializationKeys.battery] = value }
    if let value = temperature { dictionary[SerializationKeys.temperature] = value }
    if let value = airQuality { dictionary[SerializationKeys.airQuality] = value }
    if let value = humidity { dictionary[SerializationKeys.humidity] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.battery = aDecoder.decodeObject(forKey: SerializationKeys.battery) as? Int
    self.temperature = aDecoder.decodeObject(forKey: SerializationKeys.temperature) as? Int
    self.airQuality = aDecoder.decodeObject(forKey: SerializationKeys.airQuality) as? Int
    self.humidity = aDecoder.decodeObject(forKey: SerializationKeys.humidity) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(battery, forKey: SerializationKeys.battery)
    aCoder.encode(temperature, forKey: SerializationKeys.temperature)
    aCoder.encode(airQuality, forKey: SerializationKeys.airQuality)
    aCoder.encode(humidity, forKey: SerializationKeys.humidity)
  }

}
