//
//  CommuteLegs.swift
//
//  Created by John Pillar on 28/12/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CommuteLegs: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let status = "status"
    static let departurePlatform = "departurePlatform"
    static let arrivalStation = "arrivalStation"
    static let arrivalTime = "arrivalTime"
    static let disruptions = "disruptions"
    static let departureTime = "departureTime"
    static let mode = "mode"
    static let departureStation = "departureStation"
    static let duration = "duration"
    static let line = "line"
  }

  // MARK: Properties
  public var status: String?
  public var departurePlatform: String?
  public var arrivalStation: String?
  public var arrivalTime: String?
  public var disruptions: String?
  public var departureTime: String?
  public var mode: String?
  public var departureStation: String?
  public var duration: String?
  public var line: String?

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
    status = json[SerializationKeys.status].string
    departurePlatform = json[SerializationKeys.departurePlatform].string
    arrivalStation = json[SerializationKeys.arrivalStation].string
    arrivalTime = json[SerializationKeys.arrivalTime].string
    disruptions = json[SerializationKeys.disruptions].string
    departureTime = json[SerializationKeys.departureTime].string
    mode = json[SerializationKeys.mode].string
    departureStation = json[SerializationKeys.departureStation].string
    duration = json[SerializationKeys.duration].string
    line = json[SerializationKeys.line].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[SerializationKeys.status] = value }
    if let value = departurePlatform { dictionary[SerializationKeys.departurePlatform] = value }
    if let value = arrivalStation { dictionary[SerializationKeys.arrivalStation] = value }
    if let value = arrivalTime { dictionary[SerializationKeys.arrivalTime] = value }
    if let value = disruptions { dictionary[SerializationKeys.disruptions] = value }
    if let value = departureTime { dictionary[SerializationKeys.departureTime] = value }
    if let value = mode { dictionary[SerializationKeys.mode] = value }
    if let value = departureStation { dictionary[SerializationKeys.departureStation] = value }
    if let value = duration { dictionary[SerializationKeys.duration] = value }
    if let value = line { dictionary[SerializationKeys.line] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.status = aDecoder.decodeObject(forKey: SerializationKeys.status) as? String
    self.departurePlatform = aDecoder.decodeObject(forKey: SerializationKeys.departurePlatform) as? String
    self.arrivalStation = aDecoder.decodeObject(forKey: SerializationKeys.arrivalStation) as? String
    self.arrivalTime = aDecoder.decodeObject(forKey: SerializationKeys.arrivalTime) as? String
    self.disruptions = aDecoder.decodeObject(forKey: SerializationKeys.disruptions) as? String
    self.departureTime = aDecoder.decodeObject(forKey: SerializationKeys.departureTime) as? String
    self.mode = aDecoder.decodeObject(forKey: SerializationKeys.mode) as? String
    self.departureStation = aDecoder.decodeObject(forKey: SerializationKeys.departureStation) as? String
    self.duration = aDecoder.decodeObject(forKey: SerializationKeys.duration) as? String
    self.line = aDecoder.decodeObject(forKey: SerializationKeys.line) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(status, forKey: SerializationKeys.status)
    aCoder.encode(departurePlatform, forKey: SerializationKeys.departurePlatform)
    aCoder.encode(arrivalStation, forKey: SerializationKeys.arrivalStation)
    aCoder.encode(arrivalTime, forKey: SerializationKeys.arrivalTime)
    aCoder.encode(disruptions, forKey: SerializationKeys.disruptions)
    aCoder.encode(departureTime, forKey: SerializationKeys.departureTime)
    aCoder.encode(mode, forKey: SerializationKeys.mode)
    aCoder.encode(departureStation, forKey: SerializationKeys.departureStation)
    aCoder.encode(duration, forKey: SerializationKeys.duration)
    aCoder.encode(line, forKey: SerializationKeys.line)
  }

}
