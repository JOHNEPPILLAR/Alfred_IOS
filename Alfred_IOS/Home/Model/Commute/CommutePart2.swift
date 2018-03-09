//
//  CommutePart2.swift
//
//  Created by John Pillar on 09/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CommutePart2: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let disruptions = "disruptions"
    static let mode = "mode"
    static let line = "line"
  }

  // MARK: Properties
  public var disruptions: String?
  public var mode: String?
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
    disruptions = json[SerializationKeys.disruptions].string
    mode = json[SerializationKeys.mode].string
    line = json[SerializationKeys.line].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = disruptions { dictionary[SerializationKeys.disruptions] = value }
    if let value = mode { dictionary[SerializationKeys.mode] = value }
    if let value = line { dictionary[SerializationKeys.line] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.disruptions = aDecoder.decodeObject(forKey: SerializationKeys.disruptions) as? String
    self.mode = aDecoder.decodeObject(forKey: SerializationKeys.mode) as? String
    self.line = aDecoder.decodeObject(forKey: SerializationKeys.line) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(disruptions, forKey: SerializationKeys.disruptions)
    aCoder.encode(mode, forKey: SerializationKeys.mode)
    aCoder.encode(line, forKey: SerializationKeys.line)
  }

}
