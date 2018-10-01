//
//  SensorController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 01/10/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: Delegate callback functions
protocol SensorControllerDelegate: class {
    func sensorDidRecieveDataUpdate(data: [SensorsData])
    func didFailDataUpdateWithError(displayMsg: Bool)
    func sensorSaved()
}

class SensorController: NSObject {
    
    weak var delegate: SensorControllerDelegate?
    
    // Sensor data
    func getSensorData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "settings/listSensors")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [SensorsBaseClass(json: responseJSON!)] // Update data store
                self.delegate?.sensorDidRecieveDataUpdate(data: [data[0].data!]) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func saveTimerData(body: TimersRows) {
        let configuration = URLSessionConfiguration.ephemeral
        let bodyDictionary = body.dictionaryRepresentation()
        let APIbody = try! JSONSerialization.data(withJSONObject: bodyDictionary)
        let request = putAPIHeaderData(url: "settings/listSensors", body: APIbody)
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.delegate?.sensorSaved()
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
}


