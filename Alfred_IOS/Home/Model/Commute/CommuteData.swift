//
//  CommuteData.swift
//
//  Created by John Pillar on 09/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CommuteData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let part4 = "part4"
    static let part1 = "part1"
    static let anyDisruptions = "anyDisruptions"
    static let part3 = "part3"
    static let part2 = "part2"
  }

  // MARK: Properties
  public var part4: CommutePart4?
  public var part1: CommutePart1?
  public var anyDisruptions: String?
  public var part3: CommutePart3?
  public var part2: CommutePart2?

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
    part4 = CommutePart4(json: json[SerializationKeys.part4])
    part1 = CommutePart1(json: json[SerializationKeys.part1])
    anyDisruptions = json[SerializationKeys.anyDisruptions].string
    part3 = CommutePart3(json: json[SerializationKeys.part3])
    part2 = CommutePart2(json: json[SerializationKeys.part2])
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = part4 { dictionary[SerializationKeys.part4] = value.dictionaryRepresentation() }
    if let value = part1 { dictionary[SerializationKeys.part1] = value.dictionaryRepresentation() }
    if let value = anyDisruptions { dictionary[SerializationKeys.anyDisruptions] = value }
    if let value = part3 { dictionary[SerializationKeys.part3] = value.dictionaryRepresentation() }
    if let value = part2 { dictionary[SerializationKeys.part2] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.part4 = aDecoder.decodeObject(forKey: SerializationKeys.part4) as? CommutePart4
    self.part1 = aDecoder.decodeObject(forKey: SerializationKeys.part1) as? CommutePart1
    self.anyDisruptions = aDecoder.decodeObject(forKey: SerializationKeys.anyDisruptions) as? String
    self.part3 = aDecoder.decodeObject(forKey: SerializationKeys.part3) as? CommutePart3
    self.part2 = aDecoder.decodeObject(forKey: SerializationKeys.part2) as? CommutePart2
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(part4, forKey: SerializationKeys.part4)
    aCoder.encode(part1, forKey: SerializationKeys.part1)
    aCoder.encode(anyDisruptions, forKey: SerializationKeys.anyDisruptions)
    aCoder.encode(part3, forKey: SerializationKeys.part3)
    aCoder.encode(part2, forKey: SerializationKeys.part2)
  }

}
