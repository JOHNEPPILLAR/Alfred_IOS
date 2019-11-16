//
//  HouseWeatherData.swift
//
//  Created by John Pillar on 10/02/2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class HouseWeatherData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let location = "location"
    static let humidity = "humidity"
    static let battery = "battery"
    static let temperature = "temperature"
    static let nitrogen = "nitrogen"
    static let air = "air"
    static let co2 = "co2"
  }

  // MARK: Properties
  public var location: String?
  public var humidity: Float?
  public var battery: Int?
  public var temperature: Float?
  public var nitrogen: Int?
  public var air: Int?
  public var co2: Int?

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
    location = json[SerializationKeys.location].string
    humidity = json[SerializationKeys.humidity].float
    battery = json[SerializationKeys.battery].int
    temperature = json[SerializationKeys.temperature].float
    nitrogen = json[SerializationKeys.nitrogen].int
    air = json[SerializationKeys.air].int
    co2 = json[SerializationKeys.co2].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = location { dictionary[SerializationKeys.location] = value }
    if let value = humidity { dictionary[SerializationKeys.humidity] = value }
    if let value = battery { dictionary[SerializationKeys.battery] = value }
    if let value = temperature { dictionary[SerializationKeys.temperature] = value }
    if let value = nitrogen { dictionary[SerializationKeys.nitrogen] = value }
    if let value = air { dictionary[SerializationKeys.air] = value }
    if let value = co2 { dictionary[SerializationKeys.co2] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.location = aDecoder.decodeObject(forKey: SerializationKeys.location) as? String
    self.humidity = aDecoder.decodeObject(forKey: SerializationKeys.humidity) as? Float
    self.battery = aDecoder.decodeObject(forKey: SerializationKeys.battery) as? Int
    self.temperature = aDecoder.decodeObject(forKey: SerializationKeys.temperature) as? Float
    self.nitrogen = aDecoder.decodeObject(forKey: SerializationKeys.nitrogen) as? Int
    self.air = aDecoder.decodeObject(forKey: SerializationKeys.air) as? Int
    self.co2 = aDecoder.decodeObject(forKey: SerializationKeys.co2) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(location, forKey: SerializationKeys.location)
    aCoder.encode(humidity, forKey: SerializationKeys.humidity)
    aCoder.encode(battery, forKey: SerializationKeys.battery)
    aCoder.encode(temperature, forKey: SerializationKeys.temperature)
    aCoder.encode(nitrogen, forKey: SerializationKeys.nitrogen)
    aCoder.encode(air, forKey: SerializationKeys.air)
    aCoder.encode(co2, forKey: SerializationKeys.co2)
  }

}
