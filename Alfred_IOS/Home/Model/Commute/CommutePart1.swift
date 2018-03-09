//
//  CommutePart1.swift
//
//  Created by John Pillar on 09/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CommutePart1: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let firstTime = "firstTime"
    static let mode = "mode"
    static let destination = "destination"
    static let secondTime = "secondTime"
    static let disruptions = "disruptions"
    static let line = "line"
  }

  // MARK: Properties
  public var firstTime: String?
  public var mode: String?
  public var destination: String?
  public var secondTime: String?
  public var disruptions: String?
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
    firstTime = json[SerializationKeys.firstTime].string
    mode = json[SerializationKeys.mode].string
    destination = json[SerializationKeys.destination].string
    secondTime = json[SerializationKeys.secondTime].string
    disruptions = json[SerializationKeys.disruptions].string
    line = json[SerializationKeys.line].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = firstTime { dictionary[SerializationKeys.firstTime] = value }
    if let value = mode { dictionary[SerializationKeys.mode] = value }
    if let value = destination { dictionary[SerializationKeys.destination] = value }
    if let value = secondTime { dictionary[SerializationKeys.secondTime] = value }
    if let value = disruptions { dictionary[SerializationKeys.disruptions] = value }
    if let value = line { dictionary[SerializationKeys.line] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.firstTime = aDecoder.decodeObject(forKey: SerializationKeys.firstTime) as? String
    self.mode = aDecoder.decodeObject(forKey: SerializationKeys.mode) as? String
    self.destination = aDecoder.decodeObject(forKey: SerializationKeys.destination) as? String
    self.secondTime = aDecoder.decodeObject(forKey: SerializationKeys.secondTime) as? String
    self.disruptions = aDecoder.decodeObject(forKey: SerializationKeys.disruptions) as? String
    self.line = aDecoder.decodeObject(forKey: SerializationKeys.line) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(firstTime, forKey: SerializationKeys.firstTime)
    aCoder.encode(mode, forKey: SerializationKeys.mode)
    aCoder.encode(destination, forKey: SerializationKeys.destination)
    aCoder.encode(secondTime, forKey: SerializationKeys.secondTime)
    aCoder.encode(disruptions, forKey: SerializationKeys.disruptions)
    aCoder.encode(line, forKey: SerializationKeys.line)
  }

}
