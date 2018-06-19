//
//  CommuteCommuteResults.swift
//
//  Created by John Pillar on 18/06/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CommuteResults: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let recommendedMaxAgeMinutes = "recommendedMaxAgeMinutes"
    static let journeys = "journeys"
    static let lines = "lines"
    static let stopMessages = "stopMessages"
    static let order = "order"
  }

  // MARK: Properties
  public var recommendedMaxAgeMinutes: Int?
  public var journeys: [CommuteJourneys]?
  public var lines: [Any]?
  public var stopMessages: [Any]?
  public var order: Int?

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
    recommendedMaxAgeMinutes = json[SerializationKeys.recommendedMaxAgeMinutes].int
    if let items = json[SerializationKeys.journeys].array { journeys = items.map { CommuteJourneys(json: $0) } }
    if let items = json[SerializationKeys.lines].array { lines = items.map { $0.object} }
    if let items = json[SerializationKeys.stopMessages].array { stopMessages = items.map { $0.object} }
    order = json[SerializationKeys.order].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = recommendedMaxAgeMinutes { dictionary[SerializationKeys.recommendedMaxAgeMinutes] = value }
    if let value = journeys { dictionary[SerializationKeys.journeys] = value.map { $0.dictionaryRepresentation() } }
    if let value = lines { dictionary[SerializationKeys.lines] = value }
    if let value = stopMessages { dictionary[SerializationKeys.stopMessages] = value }
    if let value = order { dictionary[SerializationKeys.order] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.recommendedMaxAgeMinutes = aDecoder.decodeObject(forKey: SerializationKeys.recommendedMaxAgeMinutes) as? Int
    self.journeys = aDecoder.decodeObject(forKey: SerializationKeys.journeys) as? [CommuteJourneys]
    self.lines = aDecoder.decodeObject(forKey: SerializationKeys.lines) as? [Any]
    self.stopMessages = aDecoder.decodeObject(forKey: SerializationKeys.stopMessages) as? [Any]
    self.order = aDecoder.decodeObject(forKey: SerializationKeys.order) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(recommendedMaxAgeMinutes, forKey: SerializationKeys.recommendedMaxAgeMinutes)
    aCoder.encode(journeys, forKey: SerializationKeys.journeys)
    aCoder.encode(lines, forKey: SerializationKeys.lines)
    aCoder.encode(stopMessages, forKey: SerializationKeys.stopMessages)
    aCoder.encode(order, forKey: SerializationKeys.order)
  }

}
