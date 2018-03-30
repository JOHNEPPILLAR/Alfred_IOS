//
//  CommuteData.swift
//
//  Created by John Pillar on 30/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CommuteData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let anyDisruptions = "anyDisruptions"
    static let commuteResults = "commuteResults"
  }

  // MARK: Properties
  public var anyDisruptions: Bool? = false
  public var commuteResults: [CommuteCommuteResults]?

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
    anyDisruptions = json[SerializationKeys.anyDisruptions].boolValue
    if let items = json[SerializationKeys.commuteResults].array { commuteResults = items.map { CommuteCommuteResults(json: $0) } }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    dictionary[SerializationKeys.anyDisruptions] = anyDisruptions
    if let value = commuteResults { dictionary[SerializationKeys.commuteResults] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.anyDisruptions = aDecoder.decodeBool(forKey: SerializationKeys.anyDisruptions)
    self.commuteResults = aDecoder.decodeObject(forKey: SerializationKeys.commuteResults) as? [CommuteCommuteResults]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(anyDisruptions, forKey: SerializationKeys.anyDisruptions)
    aCoder.encode(commuteResults, forKey: SerializationKeys.commuteResults)
  }

}
