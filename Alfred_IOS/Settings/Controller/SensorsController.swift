//
//  SensorsController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 30/09/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: Delegate callback functions
protocol SensorsControllerDelegate: class {
    func sensorsDidRecieveDataUpdate(data: [SensorsData])
    func didFailDataUpdateWithError()
}

class SensorsController: NSObject {
    
    weak var delegate: SensorsControllerDelegate?
    
    func getSensorsData() {
        /*
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "settings/listSensors")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [SensorsBaseClass(json: responseJSON!)] // Update data store
                self.delegate?.sensorsDidRecieveDataUpdate(data: [data[0].data!]) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError() // Let the View controller know there was an error
            }
        })
        task.resume()
 */
    }
    
}


