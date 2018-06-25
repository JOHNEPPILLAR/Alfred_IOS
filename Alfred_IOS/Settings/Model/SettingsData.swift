//
//  SettingsData.swift
//
//  Created by John Pillar on 25/06/2018
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

class SettingsData : NSObject, NSCoding{
    
    var image : String!
    var label : String!
    var segue : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        image = json["image"].stringValue
        label = json["label"].stringValue
        segue = json["segue"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if image != nil{
            dictionary["image"] = image
        }
        if label != nil{
            dictionary["label"] = label
        }
        if segue != nil{
            dictionary["segue"] = segue
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        image = aDecoder.decodeObject(forKey: "image") as? String
        label = aDecoder.decodeObject(forKey: "label") as? String
        segue = aDecoder.decodeObject(forKey: "segue") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if image != nil{
            aCoder.encode(image, forKey: "image")
        }
        if label != nil{
            aCoder.encode(label, forKey: "label")
        }
        if segue != nil{
            aCoder.encode(segue, forKey: "segue")
        }
        
    }
    
}
