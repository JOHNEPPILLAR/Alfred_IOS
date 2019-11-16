//
//  SensorsData.swift
//
//  Created by John Pillar on 03/06/2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class SensorsData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let fertiliser = "fertiliser"
    static let plantName = "plant_name"
    static let thresholdFertilizer = "threshold_fertilizer"
    static let address = "address"
    static let thresholdMoisture = "threshold_moisture"
    static let sensorLabel = "sensor_label"
    static let moisture = "moisture"
    static let battery = "battery"
  }

  // MARK: Properties
  public var fertiliser: Int?
  public var plantName: String?
  public var thresholdFertilizer: Int?
  public var address: String?
  public var thresholdMoisture: Int?
  public var sensorLabel: String?
  public var moisture: Int?
  public var battery: Int?

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
    fertiliser = json[SerializationKeys.fertiliser].int
    plantName = json[SerializationKeys.plantName].string
    thresholdFertilizer = json[SerializationKeys.thresholdFertilizer].int
    address = json[SerializationKeys.address].string
    thresholdMoisture = json[SerializationKeys.thresholdMoisture].int
    sensorLabel = json[SerializationKeys.sensorLabel].string
    moisture = json[SerializationKeys.moisture].int
    battery = json[SerializationKeys.battery].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = fertiliser { dictionary[SerializationKeys.fertiliser] = value }
    if let value = plantName { dictionary[SerializationKeys.plantName] = value }
    if let value = thresholdFertilizer { dictionary[SerializationKeys.thresholdFertilizer] = value }
    if let value = address { dictionary[SerializationKeys.address] = value }
    if let value = thresholdMoisture { dictionary[SerializationKeys.thresholdMoisture] = value }
    if let value = sensorLabel { dictionary[SerializationKeys.sensorLabel] = value }
    if let value = moisture { dictionary[SerializationKeys.moisture] = value }
    if let value = battery { dictionary[SerializationKeys.battery] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.fertiliser = aDecoder.decodeObject(forKey: SerializationKeys.fertiliser) as? Int
    self.plantName = aDecoder.decodeObject(forKey: SerializationKeys.plantName) as? String
    self.thresholdFertilizer = aDecoder.decodeObject(forKey: SerializationKeys.thresholdFertilizer) as? Int
    self.address = aDecoder.decodeObject(forKey: SerializationKeys.address) as? String
    self.thresholdMoisture = aDecoder.decodeObject(forKey: SerializationKeys.thresholdMoisture) as? Int
    self.sensorLabel = aDecoder.decodeObject(forKey: SerializationKeys.sensorLabel) as? String
    self.moisture = aDecoder.decodeObject(forKey: SerializationKeys.moisture) as? Int
    self.battery = aDecoder.decodeObject(forKey: SerializationKeys.battery) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(fertiliser, forKey: SerializationKeys.fertiliser)
    aCoder.encode(plantName, forKey: SerializationKeys.plantName)
    aCoder.encode(thresholdFertilizer, forKey: SerializationKeys.thresholdFertilizer)
    aCoder.encode(address, forKey: SerializationKeys.address)
    aCoder.encode(thresholdMoisture, forKey: SerializationKeys.thresholdMoisture)
    aCoder.encode(sensorLabel, forKey: SerializationKeys.sensorLabel)
    aCoder.encode(moisture, forKey: SerializationKeys.moisture)
    aCoder.encode(battery, forKey: SerializationKeys.battery)
  }

}
