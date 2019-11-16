//
//  CommuteData.swift
//
//  Created by John Pillar on 28/12/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CommuteData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let journeys = "journeys"
  }

  // MARK: Properties
  public var journeys: [CommuteJourneys]?

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
    if let items = json[SerializationKeys.journeys].array { journeys = items.map { CommuteJourneys(json: $0) } }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = journeys { dictionary[SerializationKeys.journeys] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.journeys = aDecoder.decodeObject(forKey: SerializationKeys.journeys) as? [CommuteJourneys]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(journeys, forKey: SerializationKeys.journeys)
  }

}
