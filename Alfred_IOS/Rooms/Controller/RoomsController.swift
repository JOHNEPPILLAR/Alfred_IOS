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
    func chartDataDidRecieveDataUpdate(data: [RoomTempSensorData])
    func didFailLightDataUpdateWithError(displayMsg: Bool)
    func didFailDataUpdateWithError(displayMsg: Bool)
}

class RoomsController: NSObject {
    weak var delegate: RoomsControllerDelegate?
    
    func getLightRoomData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "lights/listlightgroups")
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
                self.delegate?.didFailLightDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
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
                self.delegate?.didFailLightDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func getChartData(roomID: Int, durartion: String) {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "iot/displayroomcharts?roomID=" + "\(roomID)" + "&durationSpan=" + durartion)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [RoomTempSensorBaseClass(json: responseJSON!)] // Update data store
                self.delegate?.chartDataDidRecieveDataUpdate(data: [data[0].data!]) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
}

