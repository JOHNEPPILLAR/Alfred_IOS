//
//  RoomsController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 16/02/2019.
//  Copyright © 2019 John Pillar. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

// MARK: Delegate callback functions
protocol RoomsControllerDelegate: class {
    func roomLightsDidRecieveDataUpdate(data: [RoomLightsData])
    func chartDataDidRecieveDataUpdate(data: [RoomSensorBaseClass])
    func schedulesDidRecieveDataUpdate(data: [SchedulesData])
    func motionSensorsDidRecieveDataUpdate(data: [MotionSensorsData])
    func didFailLightDataUpdateWithError(displayMsg: Bool)
    func didFailDataUpdateWithError(displayMsg: Bool)
}

class RoomsController: NSObject {
    weak var delegate: RoomsControllerDelegate?
    
    func getLightRoomData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "lightgroups")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [RoomLightsBaseData(json: responseJSON!)] // Update data store
                self.delegate?.roomLightsDidRecieveDataUpdate(data: data[0].data!) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailLightDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func UpdateLightStateValueChange(lightID: Int, lightState: Bool) {
        var lightsStatus = "off"
        if lightState { lightsStatus = "on" }
        let configuration = URLSessionConfiguration.ephemeral
        let body: [String: Any] = ["lightAction": lightsStatus]
        let APIbody: Data = try! JSONSerialization.data(withJSONObject: body, options: [])
        let request = putAPIHeaderData(url: "lightgroups/" + String(lightID), body: APIbody)
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.getLightRoomData() // Get latest data and refresh UI
            } else {
                self.delegate?.didFailLightDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func UpdateLightBrightness(lightID: Int, brightness: Int) {
        let configuration = URLSessionConfiguration.ephemeral
        var lightAction = "on"
        if (brightness < 1) { lightAction = "off" }
        let body: [String: Any] = ["lightAction": lightAction, "brightness": brightness]
        let APIbody: Data = try! JSONSerialization.data(withJSONObject: body, options: [])
        let request = putAPIHeaderData(url: "lightgroups/" + String(lightID), body: APIbody)
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.getLightRoomData() // Get latest data and refresh UI
            } else {
                self.delegate?.didFailLightDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func getChartData(roomID: Int, durartion: String) {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "displayroomcharts/" + "\(roomID)" + "?durationSpan=" + durartion)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [RoomSensorBaseClass(json: responseJSON!)] // Update data store
                self.delegate?.chartDataDidRecieveDataUpdate(data: [data[0]]) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func getSchedulesData(roomID: Int) {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "schedules/rooms/" + "\(roomID)")
        
        dump(request)
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [SchedulesBaseClass(json: responseJSON!)] // Update data store
                self.delegate?.schedulesDidRecieveDataUpdate(data: data[0].data!) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func getMotionSensorData(roomID: Int) {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "sensors/schedules/rooms/" + "\(roomID)")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [MotionSensorsBaseClass(json: responseJSON!)] // Update data store
                self.delegate?.motionSensorsDidRecieveDataUpdate(data: data[0].data!) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
}

