//
//  CommuteJourneys.swift
//
//  Created by John Pillar on 18/06/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CommuteJourneys: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let legs = "legs"
    static let duration = "duration"
    static let arrivalDateTime = "arrivalDateTime"
    static let startDateTime = "startDateTime"
  }

  // MARK: Properties
  public var legs: [CommuteLegs]?
  public var duration: Int?
  public var arrivalDateTime: String?
  public var startDateTime: String?

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
    if let items = json[SerializationKeys.legs].array { legs = items.map { CommuteLegs(json: $0) } }
    duration = json[SerializationKeys.duration].int
    arrivalDateTime = json[SerializationKeys.arrivalDateTime].string
    startDateTime = json[SerializationKeys.startDateTime].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = legs { dictionary[SerializationKeys.legs] = value.map { $0.dictionaryRepresentation() } }
    if let value = duration { dictionary[SerializationKeys.duration] = value }
    if let value = arrivalDateTime { dictionary[SerializationKeys.arrivalDateTime] = value }
    if let value = startDateTime { dictionary[SerializationKeys.startDateTime] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.legs = aDecoder.decodeObject(forKey: SerializationKeys.legs) as? [CommuteLegs]
    self.duration = aDecoder.decodeObject(forKey: SerializationKeys.duration) as? Int
    self.arrivalDateTime = aDecoder.decodeObject(forKey: SerializationKeys.arrivalDateTime) as? String
    self.startDateTime = aDecoder.decodeObject(forKey: SerializationKeys.startDateTime) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(legs, forKey: SerializationKeys.legs)
    aCoder.encode(duration, forKey: SerializationKeys.duration)
    aCoder.encode(arrivalDateTime, forKey: SerializationKeys.arrivalDateTime)
    aCoder.encode(startDateTime, forKey: SerializationKeys.startDateTime)
  }

}
