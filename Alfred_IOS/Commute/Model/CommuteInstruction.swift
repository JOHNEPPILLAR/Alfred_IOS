//
//  CommuteInstruction.swift
//
//  Created by John Pillar on 18/06/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CommuteInstruction: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let summary = "summary"
    static let detailed = "detailed"
    static let steps = "steps"
  }

  // MARK: Properties
  public var summary: String?
  public var detailed: String?
  public var steps: [Any]?

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
    summary = json[SerializationKeys.summary].string
    detailed = json[SerializationKeys.detailed].string
    if let items = json[SerializationKeys.steps].array { steps = items.map { $0.object} }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = summary { dictionary[SerializationKeys.summary] = value }
    if let value = detailed { dictionary[SerializationKeys.detailed] = value }
    if let value = steps { dictionary[SerializationKeys.steps] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.summary = aDecoder.decodeObject(forKey: SerializationKeys.summary) as? String
    self.detailed = aDecoder.decodeObject(forKey: SerializationKeys.detailed) as? String
    self.steps = aDecoder.decodeObject(forKey: SerializationKeys.steps) as? [Any]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(summary, forKey: SerializationKeys.summary)
    aCoder.encode(detailed, forKey: SerializationKeys.detailed)
    aCoder.encode(steps, forKey: SerializationKeys.steps)
  }

}
