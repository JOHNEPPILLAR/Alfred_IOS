//
//  RoomLightsControler.swift
//  Alfred_IOS
//
//  Created by John Pillar on 04/03/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: Delegate callback functions
protocol HomeControllerDelegate: class {
    func lightRoomTableDidRecieveDataUpdate(data: [RoomLightsData])
    func currentWeatherDidRecieveDataUpdate(data: [CurrentWeatherData])

    
    
    func didFailDataUpdateWithError(displayMsg: Bool)
}

class HomeController: NSObject {
    
    weak var delegate: HomeControllerDelegate?

    // Quick Glance Tiles
    func getCurrentWeatherData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "weather/today", useScheduler: false)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = JSON(data: data!)
                let data = [CurrentWeatherBaseData(json: responseJSON)] // Update data store
                self.delegate?.currentWeatherDidRecieveDataUpdate(data: [data[0].data!]) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }

    
    func turnOffLights() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "lights/alloff", useScheduler: false)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.getLightRoomData() // Refresh the data and UI
            }
        })
        task.resume()
    }

    // Light room table
    func getLightRoomData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "lights/listlightgroups", useScheduler: false)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = JSON(data: data!)
                let data = [RoomLightsBaseData(json: responseJSON)] // Update data store
                self.delegate?.lightRoomTableDidRecieveDataUpdate(data: data[0].data!) // Let the View controller know to show the data
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
                self.getLightRoomData() // Get latest data and refresh UI
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
                self.getLightRoomData() // Get latest data and refresh UI
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
}





