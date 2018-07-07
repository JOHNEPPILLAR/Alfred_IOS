//
//  InsideWeatherData.swift
//
//  Created by John Pillar on 11/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class InsideWeatherData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let insideCO2 = "insideCO2"
    static let insideTemp = "insideTemp"
  }

  // MARK: Properties
  public var insideCO2: Int?
  public var insideTemp: Int?

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
    insideCO2 = json[SerializationKeys.insideCO2].int
    insideTemp = json[SerializationKeys.insideTemp].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = insideCO2 { dictionary[SerializationKeys.insideCO2] = value }
    if let value = insideTemp { dictionary[SerializationKeys.insideTemp] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.insideCO2 = aDecoder.decodeObject(forKey: SerializationKeys.insideCO2) as? Int
    self.insideTemp = aDecoder.decodeObject(forKey: SerializationKeys.insideTemp) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(insideCO2, forKey: SerializationKeys.insideCO2)
    aCoder.encode(insideTemp, forKey: SerializationKeys.insideTemp)
  }

}
