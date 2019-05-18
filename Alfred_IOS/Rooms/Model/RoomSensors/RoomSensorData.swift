//
//  RoomSensorData.swift
//
//  Created by John Pillar on 17/05/2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class RoomSensorData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let humidity = "humidity"
    static let battery = "battery"
    static let temperature = "temperature"
    static let timeofday = "timeofday"
    static let co2 = "co2"
    static let nitrogen = "nitrogen"
    static let airQuality = "airQuality"
  }

  // MARK: Properties
  public var humidity: Double?
  public var battery: String?
  public var temperature: Float?
  public var timeofday: String?
  public var co2: Double?
  public var nitrogen: Double?
  public var airQuality: Int?

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
    humidity = json[SerializationKeys.humidity].double
    battery = json[SerializationKeys.battery].string
    temperature = json[SerializationKeys.temperature].float
    timeofday = json[SerializationKeys.timeofday].string
    co2 = json[SerializationKeys.co2].double
    nitrogen = json[SerializationKeys.nitrogen].double
    airQuality = json[SerializationKeys.airQuality].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = humidity { dictionary[SerializationKeys.humidity] = value }
    if let value = battery { dictionary[SerializationKeys.battery] = value }
    if let value = temperature { dictionary[SerializationKeys.temperature] = value }
    if let value = timeofday { dictionary[SerializationKeys.timeofday] = value }
    if let value = co2 { dictionary[SerializationKeys.co2] = value }
    if let value = nitrogen { dictionary[SerializationKeys.nitrogen] = value }
    if let value = airQuality { dictionary[SerializationKeys.airQuality] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.humidity = aDecoder.decodeObject(forKey: SerializationKeys.humidity) as? Double
    self.battery = aDecoder.decodeObject(forKey: SerializationKeys.battery) as? String
    self.temperature = aDecoder.decodeObject(forKey: SerializationKeys.temperature) as? Float
    self.timeofday = aDecoder.decodeObject(forKey: SerializationKeys.timeofday) as? String
    self.co2 = aDecoder.decodeObject(forKey: SerializationKeys.co2) as? Double
    self.nitrogen = aDecoder.decodeObject(forKey: SerializationKeys.nitrogen) as? Double
    self.airQuality = aDecoder.decodeObject(forKey: SerializationKeys.airQuality) as? Int
}

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(humidity, forKey: SerializationKeys.humidity)
    aCoder.encode(battery, forKey: SerializationKeys.battery)
    aCoder.encode(temperature, forKey: SerializationKeys.temperature)
    aCoder.encode(timeofday, forKey: SerializationKeys.timeofday)
    aCoder.encode(co2, forKey: SerializationKeys.co2)
    aCoder.encode(nitrogen, forKey: SerializationKeys.nitrogen)
    aCoder.encode(airQuality, forKey: SerializationKeys.airQuality)
  }

}
