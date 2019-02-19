//
//  ViewTimersController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 09/09/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: Delegate callback functions
protocol TimersControllerDelegate: class {
    func timersDidRecieveDataUpdate(data: [TimersData])
    func didFailDataUpdateWithError()
}

class TimersController: NSObject {
    
    weak var delegate: TimersControllerDelegate?
    
    func getTimerData() {
        /*
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "settings/listSchedules")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [TimersBaseClass(json: responseJSON!)] // Update data store
                self.delegate?.timersDidRecieveDataUpdate(data: [data[0].data!]) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError() // Let the View controller know there was an error
            }
        })
        task.resume()
 */
    }
    
}


