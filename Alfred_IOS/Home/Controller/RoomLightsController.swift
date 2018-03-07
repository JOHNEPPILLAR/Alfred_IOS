//
//  RoomLightsControler.swift
//  Alfred_IOS
//
//  Created by John Pillar on 04/03/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: Quick Glance Tiles
class HomeQuickGlanceTiles: NSObject {
    
}

// MARK: Room Light Table Actions
protocol RoomLightsControllerDelegate: class {
    func didRecieveDataUpdate(data: [RoomLightsData])
    func didFailDataUpdateWithError(displayMsg: Bool)
}

class RoomLightsController: NSObject {
    
    weak var delegate: RoomLightsControllerDelegate?
    
    func requestData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "lights/listlightgroups", useScheduler: false)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = JSON(data: data!)
                let data = [RoomLightsBaseData(json: responseJSON)] // Update data store
                self.delegate?.didRecieveDataUpdate(data: data[0].data!) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func UpdateLightBrightness(lightID: Int, brightness: Int) {
        let configuration = URLSessionConfiguration.ephemeral
        let body: [String: Any] = ["light_number": lightID, "brightness": brightness]
        let APIbody: Data = try! JSONSerialization.data(withJSONObject: body, options: [])
        let request = putAPIHeaderData(url: "lights/lightgroupbrightness", body: APIbody, useScheduler: false)
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.requestData() // Get latest data and refresh UI
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func UpdatePowerButtonValueChange(lightID: String, lightState: Bool) {

        var lightsStatus = "off"
        if !lightState {
            lightsStatus = "on"
        }
        
        let configuration = URLSessionConfiguration.ephemeral
        let body: [String: Any] = ["light_number": lightID, "light_status": lightsStatus]
        let APIbody: Data = try! JSONSerialization.data(withJSONObject: body, options: [])
        let request = putAPIHeaderData(url: "lights/lightgrouponoff", body: APIbody, useScheduler: false)
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.requestData() // Get latest data and refresh UI
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }

    
    // Quick glance
    func turnOffLights() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "lights/alloff", useScheduler: false)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.requestData() // Refresh the data and UI
            }
        })
        task.resume()
    }

}





