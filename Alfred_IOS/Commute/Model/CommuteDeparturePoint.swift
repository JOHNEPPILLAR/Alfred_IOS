//
//  CommuteDeparturePoint.swift
//
//  Created by John Pillar on 18/06/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CommuteDeparturePoint: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let commonName = "commonName"
    static let platformName = "platformName"
    static let naptanId = "naptanId"
    static let icsCode = "icsCode"
    static let lon = "lon"
    static let additionalProperties = "additionalProperties"
    static let lat = "lat"
    static let placeType = "placeType"
  }

  // MARK: Properties
  public var commonName: String?
  public var platformName: String?
  public var naptanId: String?
  public var icsCode: String?
  public var lon: Float?
  public var additionalProperties: [Any]?
  public var lat: Float?
  public var placeType: String?

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
    commonName = json[SerializationKeys.commonName].string
    platformName = json[SerializationKeys.platformName].string
    naptanId = json[SerializationKeys.naptanId].string
    icsCode = json[SerializationKeys.icsCode].string
    lon = json[SerializationKeys.lon].float
    if let items = json[SerializationKeys.additionalProperties].array { additionalProperties = items.map { $0.object} }
    lat = json[SerializationKeys.lat].float
    placeType = json[SerializationKeys.placeType].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = commonName { dictionary[SerializationKeys.commonName] = value }
    if let value = platformName { dictionary[SerializationKeys.platformName] = value }
    if let value = naptanId { dictionary[SerializationKeys.naptanId] = value }
    if let value = icsCode { dictionary[SerializationKeys.icsCode] = value }
    if let value = lon { dictionary[SerializationKeys.lon] = value }
    if let value = additionalProperties { dictionary[SerializationKeys.additionalProperties] = value }
    if let value = lat { dictionary[SerializationKeys.lat] = value }
    if let value = placeType { dictionary[SerializationKeys.placeType] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.commonName = aDecoder.decodeObject(forKey: SerializationKeys.commonName) as? String
    self.platformName = aDecoder.decodeObject(forKey: SerializationKeys.platformName) as? String
    self.naptanId = aDecoder.decodeObject(forKey: SerializationKeys.naptanId) as? String
    self.icsCode = aDecoder.decodeObject(forKey: SerializationKeys.icsCode) as? String
    self.lon = aDecoder.decodeObject(forKey: SerializationKeys.lon) as? Float
    self.additionalProperties = aDecoder.decodeObject(forKey: SerializationKeys.additionalProperties) as? [Any]
    self.lat = aDecoder.decodeObject(forKey: SerializationKeys.lat) as? Float
    self.placeType = aDecoder.decodeObject(forKey: SerializationKeys.placeType) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(commonName, forKey: SerializationKeys.commonName)
    aCoder.encode(platformName, forKey: SerializationKeys.platformName)
    aCoder.encode(naptanId, forKey: SerializationKeys.naptanId)
    aCoder.encode(icsCode, forKey: SerializationKeys.icsCode)
    aCoder.encode(lon, forKey: SerializationKeys.lon)
    aCoder.encode(additionalProperties, forKey: SerializationKeys.additionalProperties)
    aCoder.encode(lat, forKey: SerializationKeys.lat)
    aCoder.encode(placeType, forKey: SerializationKeys.placeType)
  }

}
