//
//  TimersData.swift
//
//  Created by John Pillar on 08/09/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class TimersData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let rowAsArray = "rowAsArray"
    static let rowCount = "rowCount"
    static let rows = "rows"
    static let command = "command"
  }

  // MARK: Properties
  public var rowAsArray: Bool? = false
  public var rowCount: Int?
  public var rows: [TimersRows]?
  public var command: String?

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
    rowAsArray = json[SerializationKeys.rowAsArray].boolValue
    rowCount = json[SerializationKeys.rowCount].int
    if let items = json[SerializationKeys.rows].array { rows = items.map { TimersRows(json: $0) } }
    command = json[SerializationKeys.command].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    dictionary[SerializationKeys.rowAsArray] = rowAsArray
    if let value = rowCount { dictionary[SerializationKeys.rowCount] = value }
    if let value = rows { dictionary[SerializationKeys.rows] = value.map { $0.dictionaryRepresentation() } }
    if let value = command { dictionary[SerializationKeys.command] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.rowAsArray = aDecoder.decodeBool(forKey: SerializationKeys.rowAsArray)
    self.rowCount = aDecoder.decodeObject(forKey: SerializationKeys.rowCount) as? Int
    self.rows = aDecoder.decodeObject(forKey: SerializationKeys.rows) as? [TimersRows]
    self.command = aDecoder.decodeObject(forKey: SerializationKeys.command) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(rowAsArray, forKey: SerializationKeys.rowAsArray)
    aCoder.encode(rowCount, forKey: SerializationKeys.rowCount)
    aCoder.encode(rows, forKey: SerializationKeys.rows)
    aCoder.encode(command, forKey: SerializationKeys.command)
  }

}
