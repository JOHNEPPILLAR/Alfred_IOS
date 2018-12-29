//
//  LightController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 16/12/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: Delegate callback functions
protocol LightsControllerDelegate: class {
    func lightRoomTableDidRecieveDataUpdate(data: [RoomLightsData])
    func didFailDataUpdateWithError(displayMsg: Bool)
}

class LightsController: NSObject {
    weak var delegate: LightsControllerDelegate?
    
    func turnOffLights() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "lights/alloff")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.getLightRoomData()
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    // Light room table
    func getLightRoomData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "lights/listlightgroups")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [RoomLightsBaseData(json: responseJSON!)] // Update data store
                self.delegate?.lightRoomTableDidRecieveDataUpdate(data: data[0].data!) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func UpdateLightBrightness(lightID: Int, brightness: Int) {
        let configuration = URLSessionConfiguration.ephemeral
        let body: [String: Any] = ["lightGroupNumber": lightID, "brightness": brightness]
        let APIbody: Data = try! JSONSerialization.data(withJSONObject: body, options: [])
        let request = putAPIHeaderData(url: "lights/lightgroupbrightness", body: APIbody)
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.getLightRoomData() // Get latest data and refresh UI
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func UpdateLightStateValueChange(lightID: Int, lightState: Bool) {
        var lightsStatus = "off"
        if lightState {
            lightsStatus = "on"
        }
        let configuration = URLSessionConfiguration.ephemeral
        let body: [String: Any] = ["lightGroupNumber": lightID, "lightAction": lightsStatus]
        let APIbody: Data = try! JSONSerialization.data(withJSONObject: body, options: [])
        let request = putAPIHeaderData(url: "lights/lightgrouponoff", body: APIbody)
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.getLightRoomData() // Get latest data and refresh UI
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
}





