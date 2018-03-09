//
//  CurrentWeatherBaseClass.swift
//  Alfred_IOS
//
//  Created by John Pillar on 09/03/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CurrentWeatherBaseData: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let data = "data"
        static let sucess = "sucess"
    }
    
    // MARK: Properties
    public var data: CurrentWeatherData?
    public var sucess: String?
    
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
        data = CurrentWeatherData(json: json[SerializationKeys.data])
        sucess = json[SerializationKeys.sucess].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = data { dictionary[SerializationKeys.data] = value.dictionaryRepresentation() }
        if let value = sucess { dictionary[SerializationKeys.sucess] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.data = aDecoder.decodeObject(forKey: SerializationKeys.data) as? CurrentWeatherData
        self.sucess = aDecoder.decodeObject(forKey: SerializationKeys.sucess) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(data, forKey: SerializationKeys.data)
        aCoder.encode(sucess, forKey: SerializationKeys.sucess)
    }
    
}
