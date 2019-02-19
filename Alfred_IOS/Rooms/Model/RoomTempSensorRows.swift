//
//  RoomTempSensorRows.swift
//
//  Created by John Pillar on 18/02/2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class RoomTempSensorRows: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let humidity = "humidity"
    static let airQuality = "air_quality"
    static let temperature = "temperature"
    static let nitrogen = "nitrogen"
    static let battery = "battery"
    static let time = "time"
  }

  // MARK: Properties
  public var humidity: Float?
  public var airQuality: Int?
  public var temperature: Float?
  public var nitrogen: Int?
  public var battery: String?
  public var time: String?

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
    humidity = json[SerializationKeys.humidity].float
    airQuality = json[SerializationKeys.airQuality].int
    temperature = json[SerializationKeys.temperature].float
    nitrogen = json[SerializationKeys.nitrogen].int
    battery = json[SerializationKeys.battery].string
    time = json[SerializationKeys.time].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = humidity { dictionary[SerializationKeys.humidity] = value }
    if let value = airQuality { dictionary[SerializationKeys.airQuality] = value }
    if let value = temperature { dictionary[SerializationKeys.temperature] = value }
    if let value = nitrogen { dictionary[SerializationKeys.nitrogen] = value }
    if let value = battery { dictionary[SerializationKeys.battery] = value }
    if let value = time { dictionary[SerializationKeys.time] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.humidity = aDecoder.decodeObject(forKey: SerializationKeys.humidity) as? Float
    self.airQuality = aDecoder.decodeObject(forKey: SerializationKeys.airQuality) as? Int
    self.temperature = aDecoder.decodeObject(forKey: SerializationKeys.temperature) as? Float
    self.nitrogen = aDecoder.decodeObject(forKey: SerializationKeys.nitrogen) as? Int
    self.battery = aDecoder.decodeObject(forKey: SerializationKeys.battery) as? String
    self.time = aDecoder.decodeObject(forKey: SerializationKeys.time) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(humidity, forKey: SerializationKeys.humidity)
    aCoder.encode(airQuality, forKey: SerializationKeys.airQuality)
    aCoder.encode(temperature, forKey: SerializationKeys.temperature)
    aCoder.encode(nitrogen, forKey: SerializationKeys.nitrogen)
    aCoder.encode(battery, forKey: SerializationKeys.battery)
    aCoder.encode(time, forKey: SerializationKeys.time)
  }

}
