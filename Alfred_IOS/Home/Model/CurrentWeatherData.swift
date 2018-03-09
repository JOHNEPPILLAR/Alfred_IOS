//
//  CurrentWeatherData.swift
//  Alfred_IOS
//
//  Created by John Pillar on 09/03/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CurrentWeatherData: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let summary = "summary"
        static let icon = "icon"
        static let temperatureLow = "temperatureLow"
        static let locationName = "locationName"
        static let temperature = "temperature"
        static let apparentTemperature = "apparentTemperature"
        static let temperatureHigh = "temperatureHigh"
    }
    
    // MARK: Properties
    public var summary: String?
    public var icon: String?
    public var temperatureLow: Int?
    public var locationName: String?
    public var temperature: Int?
    public var apparentTemperature: Int?
    public var temperatureHigh: Int?
    
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
        icon = json[SerializationKeys.icon].string
        temperatureLow = json[SerializationKeys.temperatureLow].int
        locationName = json[SerializationKeys.locationName].string
        temperature = json[SerializationKeys.temperature].int
        apparentTemperature = json[SerializationKeys.apparentTemperature].int
        temperatureHigh = json[SerializationKeys.temperatureHigh].int
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = summary { dictionary[SerializationKeys.summary] = value }
        if let value = icon { dictionary[SerializationKeys.icon] = value }
        if let value = temperatureLow { dictionary[SerializationKeys.temperatureLow] = value }
        if let value = locationName { dictionary[SerializationKeys.locationName] = value }
        if let value = temperature { dictionary[SerializationKeys.temperature] = value }
        if let value = apparentTemperature { dictionary[SerializationKeys.apparentTemperature] = value }
        if let value = temperatureHigh { dictionary[SerializationKeys.temperatureHigh] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.summary = aDecoder.decodeObject(forKey: SerializationKeys.summary) as? String
        self.icon = aDecoder.decodeObject(forKey: SerializationKeys.icon) as? String
        self.temperatureLow = aDecoder.decodeObject(forKey: SerializationKeys.temperatureLow) as? Int
        self.locationName = aDecoder.decodeObject(forKey: SerializationKeys.locationName) as? String
        self.temperature = aDecoder.decodeObject(forKey: SerializationKeys.temperature) as? Int
        self.apparentTemperature = aDecoder.decodeObject(forKey: SerializationKeys.apparentTemperature) as? Int
        self.temperatureHigh = aDecoder.decodeObject(forKey: SerializationKeys.temperatureHigh) as? Int
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(summary, forKey: SerializationKeys.summary)
        aCoder.encode(icon, forKey: SerializationKeys.icon)
        aCoder.encode(temperatureLow, forKey: SerializationKeys.temperatureLow)
        aCoder.encode(locationName, forKey: SerializationKeys.locationName)
        aCoder.encode(temperature, forKey: SerializationKeys.temperature)
        aCoder.encode(apparentTemperature, forKey: SerializationKeys.apparentTemperature)
        aCoder.encode(temperatureHigh, forKey: SerializationKeys.temperatureHigh)
    }
    
}
