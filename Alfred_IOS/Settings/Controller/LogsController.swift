//
//  ViewAPILogsController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 23/03/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: Delegate callback functions
protocol LogsControllerDelegate: class {
    func logsDidRecieveDataUpdate(data: [LogsData])
    func didFailDataUpdateWithError()
}

class LogsController: NSObject {
    
    weak var delegate: LogsControllerDelegate?
    
    func getLogData(page: Int) {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "display")
        //        let request = getAPIHeaderData(url: "display?page=" + String(page))
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [LogsBaseClass(json: responseJSON!)] // Update data store
                self.delegate?.logsDidRecieveDataUpdate(data: data[0].data!) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError() // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
}


