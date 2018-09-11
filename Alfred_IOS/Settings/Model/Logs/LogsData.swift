//
//  Data.swift
//
//  Created by John Pillar on 27/06/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class LogsData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let service = "service"
    static let message = "message"
    static let type = "type"
    static let time = "time"
    static let functionName = "function_name"
  }

  // MARK: Properties
  public var service: String?
  public var message: String?
  public var type: String?
  public var time: String?
  public var functionName: String?

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
    service = json[SerializationKeys.service].string
    message = json[SerializationKeys.message].string
    type = json[SerializationKeys.type].string
    time = json[SerializationKeys.time].string
    functionName = json[SerializationKeys.functionName].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = service { dictionary[SerializationKeys.service] = value }
    if let value = message { dictionary[SerializationKeys.message] = value }
    if let value = type { dictionary[SerializationKeys.type] = value }
    if let value = time { dictionary[SerializationKeys.time] = value }
    if let value = functionName { dictionary[SerializationKeys.functionName] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.service = aDecoder.decodeObject(forKey: SerializationKeys.service) as? String
    self.message = aDecoder.decodeObject(forKey: SerializationKeys.message) as? String
    self.type = aDecoder.decodeObject(forKey: SerializationKeys.type) as? String
    self.time = aDecoder.decodeObject(forKey: SerializationKeys.time) as? String
    self.functionName = aDecoder.decodeObject(forKey: SerializationKeys.functionName) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(service, forKey: SerializationKeys.service)
    aCoder.encode(message, forKey: SerializationKeys.message)
    aCoder.encode(type, forKey: SerializationKeys.type)
    aCoder.encode(time, forKey: SerializationKeys.time)
    aCoder.encode(functionName, forKey: SerializationKeys.functionName)
  }

}
