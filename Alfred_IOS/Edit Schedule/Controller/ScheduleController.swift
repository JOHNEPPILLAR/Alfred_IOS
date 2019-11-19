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
protocol ScheduleControllerDelegate: class {
    func scheduleDidRecieveDataUpdate(data: [SchedulesData])
    func didFailDataUpdateWithError(displayMsg: Bool)
    func scheduleSaved()
}

class ScheduleController: NSObject {
    
    weak var delegate: ScheduleControllerDelegate?
    
    // Schedule data
    func getScheduleData(scheduleID: Int) {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "schedules/" + "\(scheduleID)")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [SchedulesBaseClass(json: responseJSON!)] // Update data store
                self.delegate?.scheduleDidRecieveDataUpdate(data: data[0].data!) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func saveScheduleData(scheduleID: Int, body: SchedulesData) {
        let configuration = URLSessionConfiguration.ephemeral
        let bodyDictionary = body.dictionaryRepresentation()
        let APIbody = try! JSONSerialization.data(withJSONObject: bodyDictionary)
        let request = putAPIHeaderData(url: "schedules/" + "\(scheduleID)", body: APIbody)
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.delegate?.scheduleSaved()
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
}
