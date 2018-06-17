//
//  LightsOffController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 31/03/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: Delegate callback functions
protocol LightsOffControllerDelegate: class {
    func didRecieveLightsOffDataUpdate(data: [SettingsOff])
    func didSaveLightsOffDataUpdate()
    func didFailDataUpdateWithError(displayMsg: Bool)
}

class LightsOffController: NSObject {
    
    weak var delegate: LightsOffControllerDelegate?
    
    func getData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "settings/view")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let baseData = [SettingsBaseClass(json: responseJSON!)] // Update data store
                let data = baseData[0].data?.off
                self.delegate?.didRecieveLightsOffDataUpdate(data: [data!]) // Let the View controller know to update screen
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func saveLightsOffData(data: [SettingsOff]) {
        
        // Call Alfred scheduler to update the settings
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let body = try! JSONSerialization.data(withJSONObject: data[0].dictionaryRepresentation(), options: [])
        let request = putAPIHeaderData(url: "settings/savelightsoff", body: body)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.delegate?.didSaveLightsOffDataUpdate() // Let the View controller know to update screen
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
}

