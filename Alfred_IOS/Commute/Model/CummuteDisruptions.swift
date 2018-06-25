//
//  CummuteDisruptions.swift
//
//  Created by John Pillar on 22/06/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CummuteDisruptions: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let category = "category"
    static let type = "type"
    static let categoryDescription = "categoryDescription"
    static let description = "description"
    static let summary = "summary"
  }

  // MARK: Properties
  public var category: String?
  public var type: String?
  public var categoryDescription: String?
  public var description: String?
  public var summary: String?

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
    category = json[SerializationKeys.category].string
    type = json[SerializationKeys.type].string
    categoryDescription = json[SerializationKeys.categoryDescription].string
    description = json[SerializationKeys.description].string
    summary = json[SerializationKeys.summary].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = category { dictionary[SerializationKeys.category] = value }
    if let value = type { dictionary[SerializationKeys.type] = value }
    if let value = categoryDescription { dictionary[SerializationKeys.categoryDescription] = value }
    if let value = description { dictionary[SerializationKeys.description] = value }
    if let value = summary { dictionary[SerializationKeys.summary] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.category = aDecoder.decodeObject(forKey: SerializationKeys.category) as? String
    self.type = aDecoder.decodeObject(forKey: SerializationKeys.type) as? String
    self.categoryDescription = aDecoder.decodeObject(forKey: SerializationKeys.categoryDescription) as? String
    self.description = aDecoder.decodeObject(forKey: SerializationKeys.description) as? String
    self.summary = aDecoder.decodeObject(forKey: SerializationKeys.summary) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(category, forKey: SerializationKeys.category)
    aCoder.encode(type, forKey: SerializationKeys.type)
    aCoder.encode(categoryDescription, forKey: SerializationKeys.categoryDescription)
    aCoder.encode(description, forKey: SerializationKeys.description)
    aCoder.encode(summary, forKey: SerializationKeys.summary)
  }
}
