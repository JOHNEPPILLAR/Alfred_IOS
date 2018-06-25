//
//  CommuteLegs.swift
//
//  Created by John Pillar on 18/06/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CommuteLegs: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let arrivalPoint = "arrivalPoint"
    static let isDisrupted = "isDisrupted"
    static let arrivalTime = "arrivalTime"
    static let plannedWorks = "plannedWorks"
    static let obstacles = "obstacles"
    static let mode = "mode"
    static let hasFixedLocations = "hasFixedLocations"
    static let instruction = "instruction"
    static let departureTime = "departureTime"
    static let routeOptions = "routeOptions"
    static let disruptions = "disruptions"
    static let duration = "duration"
    static let departurePoint = "departurePoint"
  }

  // MARK: Properties
  public var arrivalPoint: CommuteArrivalPoint?
  public var isDisrupted: Bool? = false
  public var arrivalTime: String?
  public var plannedWorks: [Any]?
  public var obstacles: [Any]?
  public var mode: CommuteMode?
  public var hasFixedLocations: Bool? = false
  public var instruction: CommuteInstruction?
  public var departureTime: String?
  public var routeOptions: [CommuteRouteOptions]?
  public var disruptions: [CummuteDisruptions]?
  public var duration: Int?
  public var departurePoint: CommuteDeparturePoint?

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
    arrivalPoint = CommuteArrivalPoint(json: json[SerializationKeys.arrivalPoint])
    isDisrupted = json[SerializationKeys.isDisrupted].boolValue
    arrivalTime = json[SerializationKeys.arrivalTime].string
    if let items = json[SerializationKeys.plannedWorks].array { plannedWorks = items.map { $0.object} }
    if let items = json[SerializationKeys.obstacles].array { obstacles = items.map { $0.object} }
    mode = CommuteMode(json: json[SerializationKeys.mode])
    hasFixedLocations = json[SerializationKeys.hasFixedLocations].boolValue
    instruction = CommuteInstruction(json: json[SerializationKeys.instruction])
    departureTime = json[SerializationKeys.departureTime].string
    if let items = json[SerializationKeys.routeOptions].array { routeOptions = items.map { CommuteRouteOptions(json: $0) } }
    if let items = json[SerializationKeys.disruptions].array { disruptions = items.map { CummuteDisruptions(json: $0) } }
    duration = json[SerializationKeys.duration].int
    departurePoint = CommuteDeparturePoint(json: json[SerializationKeys.departurePoint])
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = arrivalPoint { dictionary[SerializationKeys.arrivalPoint] = value.dictionaryRepresentation() }
    dictionary[SerializationKeys.isDisrupted] = isDisrupted
    if let value = arrivalTime { dictionary[SerializationKeys.arrivalTime] = value }
    if let value = plannedWorks { dictionary[SerializationKeys.plannedWorks] = value }
    if let value = obstacles { dictionary[SerializationKeys.obstacles] = value }
    if let value = mode { dictionary[SerializationKeys.mode] = value.dictionaryRepresentation() }
    dictionary[SerializationKeys.hasFixedLocations] = hasFixedLocations
    if let value = instruction { dictionary[SerializationKeys.instruction] = value.dictionaryRepresentation() }
    if let value = departureTime { dictionary[SerializationKeys.departureTime] = value }
    if let value = routeOptions { dictionary[SerializationKeys.routeOptions] = value.map { $0.dictionaryRepresentation() } }
    if let value = disruptions { dictionary[SerializationKeys.disruptions] = value.map { $0.dictionaryRepresentation() } }
    if let value = duration { dictionary[SerializationKeys.duration] = value }
    if let value = departurePoint { dictionary[SerializationKeys.departurePoint] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.arrivalPoint = aDecoder.decodeObject(forKey: SerializationKeys.arrivalPoint) as? CommuteArrivalPoint
    self.isDisrupted = aDecoder.decodeBool(forKey: SerializationKeys.isDisrupted)
    self.arrivalTime = aDecoder.decodeObject(forKey: SerializationKeys.arrivalTime) as? String
    self.plannedWorks = aDecoder.decodeObject(forKey: SerializationKeys.plannedWorks) as? [Any]
    self.obstacles = aDecoder.decodeObject(forKey: SerializationKeys.obstacles) as? [Any]
    self.mode = aDecoder.decodeObject(forKey: SerializationKeys.mode) as? CommuteMode
    self.hasFixedLocations = aDecoder.decodeBool(forKey: SerializationKeys.hasFixedLocations)
    self.instruction = aDecoder.decodeObject(forKey: SerializationKeys.instruction) as? CommuteInstruction
    self.departureTime = aDecoder.decodeObject(forKey: SerializationKeys.departureTime) as? String
    self.routeOptions = aDecoder.decodeObject(forKey: SerializationKeys.routeOptions) as? [CommuteRouteOptions]
    self.disruptions = aDecoder.decodeObject(forKey: SerializationKeys.disruptions) as? [CummuteDisruptions]
    self.duration = aDecoder.decodeObject(forKey: SerializationKeys.duration) as? Int
    self.departurePoint = aDecoder.decodeObject(forKey: SerializationKeys.departurePoint) as? CommuteDeparturePoint
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(arrivalPoint, forKey: SerializationKeys.arrivalPoint)
    aCoder.encode(isDisrupted, forKey: SerializationKeys.isDisrupted)
    aCoder.encode(arrivalTime, forKey: SerializationKeys.arrivalTime)
    aCoder.encode(plannedWorks, forKey: SerializationKeys.plannedWorks)
    aCoder.encode(obstacles, forKey: SerializationKeys.obstacles)
    aCoder.encode(mode, forKey: SerializationKeys.mode)
    aCoder.encode(hasFixedLocations, forKey: SerializationKeys.hasFixedLocations)
    aCoder.encode(instruction, forKey: SerializationKeys.instruction)
    aCoder.encode(departureTime, forKey: SerializationKeys.departureTime)
    aCoder.encode(routeOptions, forKey: SerializationKeys.routeOptions)
    aCoder.encode(disruptions, forKey: SerializationKeys.disruptions)
    aCoder.encode(duration, forKey: SerializationKeys.duration)
    aCoder.encode(departurePoint, forKey: SerializationKeys.departurePoint)
  }

}
