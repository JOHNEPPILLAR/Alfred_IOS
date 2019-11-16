//
//  GardenController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 02/06/2019.
//  Copyright © 2019 John Pillar. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

// MARK: Delegate callback functions
protocol GardenControllerDelegate: class {
    func chartDataDidRecieveDataUpdate(data: [RoomSensorBaseClass])
    func sensorDataDidRecieveDataUpdate(data: [SensorsBaseClass])
    func schedulesDidRecieveDataUpdate(data: [SchedulesData])
    func didFailDataUpdateWithError(displayMsg: Bool)
}

class GardenController: NSObject {
    weak var delegate: GardenControllerDelegate?

    func getChartData(durartion: String) {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "iot/displayroomcharts?roomID=G" + "&durationSpan=" + durartion)
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

    func getSchedulesData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "schedules/list?roomNumber=G")
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
    
    func getSensorData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "iot/displaycureentgardendata")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [SensorsBaseClass(json: responseJSON!)] // Update data store
                self.delegate?.sensorDataDidRecieveDataUpdate(data: [data[0]]) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
}
