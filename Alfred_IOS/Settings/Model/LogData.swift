//
//  LogData.swift
//
//  Created by John Pillar on 24/03/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class LogData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let currentpage = "currentpage"
    static let pages = "pages"
    static let lpm1 = "lpm1"
    static let prevpage = "prevpage"
    static let logs = "logs"
    static let lastpage = "lastpage"
    static let nextpage = "nextpage"
  }

  // MARK: Properties
  public var currentpage: Int?
  public var pages: [Int]?
  public var lpm1: Int?
  public var prevpage: Int?
  public var logs: [LogLogs]?
  public var lastpage: Int?
  public var nextpage: Int?

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
    currentpage = json[SerializationKeys.currentpage].int
    if let items = json[SerializationKeys.pages].array { pages = items.map { $0.intValue } }
    lpm1 = json[SerializationKeys.lpm1].int
    prevpage = json[SerializationKeys.prevpage].int
    if let items = json[SerializationKeys.logs].array { logs = items.map { LogLogs(json: $0) } }
    lastpage = json[SerializationKeys.lastpage].int
    nextpage = json[SerializationKeys.nextpage].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = currentpage { dictionary[SerializationKeys.currentpage] = value }
    if let value = pages { dictionary[SerializationKeys.pages] = value }
    if let value = lpm1 { dictionary[SerializationKeys.lpm1] = value }
    if let value = prevpage { dictionary[SerializationKeys.prevpage] = value }
    if let value = logs { dictionary[SerializationKeys.logs] = value.map { $0.dictionaryRepresentation() } }
    if let value = lastpage { dictionary[SerializationKeys.lastpage] = value }
    if let value = nextpage { dictionary[SerializationKeys.nextpage] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.currentpage = aDecoder.decodeObject(forKey: SerializationKeys.currentpage) as? Int
    self.pages = aDecoder.decodeObject(forKey: SerializationKeys.pages) as? [Int]
    self.lpm1 = aDecoder.decodeObject(forKey: SerializationKeys.lpm1) as? Int
    self.prevpage = aDecoder.decodeObject(forKey: SerializationKeys.prevpage) as? Int
    self.logs = aDecoder.decodeObject(forKey: SerializationKeys.logs) as? [LogLogs]
    self.lastpage = aDecoder.decodeObject(forKey: SerializationKeys.lastpage) as? Int
    self.nextpage = aDecoder.decodeObject(forKey: SerializationKeys.nextpage) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(currentpage, forKey: SerializationKeys.currentpage)
    aCoder.encode(pages, forKey: SerializationKeys.pages)
    aCoder.encode(lpm1, forKey: SerializationKeys.lpm1)
    aCoder.encode(prevpage, forKey: SerializationKeys.prevpage)
    aCoder.encode(logs, forKey: SerializationKeys.logs)
    aCoder.encode(lastpage, forKey: SerializationKeys.lastpage)
    aCoder.encode(nextpage, forKey: SerializationKeys.nextpage)
  }

}
