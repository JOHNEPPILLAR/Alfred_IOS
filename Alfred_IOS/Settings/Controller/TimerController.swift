//
//  ViewTimerController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 15/09/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: Delegate callback functions
protocol TimerControllerDelegate: class {
    func timerDidRecieveDataUpdate(data: [TimersData])
    func didFailDataUpdateWithError(displayMsg: Bool)
    func timerSaved()
    func lightRoomDidRecieveDataUpdate(data: [RoomLightsData])
}

class TimerController: NSObject {
    
    weak var delegate: TimerControllerDelegate?
    
    // Timer data
    func getTimerData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "settings/listSchedules")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [TimersBaseClass(json: responseJSON!)] // Update data store
                self.delegate?.timerDidRecieveDataUpdate(data: [data[0].data!]) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func saveTimerData(body: [String : Any]) {
        let configuration = URLSessionConfiguration.ephemeral
        let APIbody: Data = try! JSONSerialization.data(withJSONObject: body, options: [])
        let request = putAPIHeaderData(url: "settings/saveSchedule", body: APIbody)
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.delegate?.timerSaved()
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    // Light room data
    func getLightRoomData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "lights/listlightgroups")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [RoomLightsBaseData(json: responseJSON!)] // Update data store
                self.delegate?.lightRoomDidRecieveDataUpdate(data: data[0].data!) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
}


