//
//  SunRiseController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 31/03/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: Delegate callback functions
protocol SunriseControllerDelegate: class {
    func didRecieveSunriseTimeUpdate(data: String)
    func didRecieveSunriseDataUpdate(data: [SettingsMorning])
    func didSaveSunriseDataUpdate()
    func didFailDataUpdateWithError(displayMsg: Bool)
}

class SunriseController: NSObject {
    
    weak var delegate: SunriseControllerDelegate?
    
    func getSunRiseTime() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "weather/sunrise")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let json = try? JSON(data: data!)
                let Sunset = json!["data"].string! // Save json to custom classes
                self.delegate?.didRecieveSunriseTimeUpdate(data: Sunset) // Let the View controller know to update screen
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func getSunRiseData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "settings/view")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let baseData = [SettingsBaseClass(json: responseJSON!)] // Update data store
                let data = baseData[0].data?.on?.morning
                self.delegate?.didRecieveSunriseDataUpdate(data: [data!]) // Let the View controller know to update screen
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func saveSunriseData(data: [SettingsMorning]) {
        
        // Call Alfred scheduler to update the settings
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let body = try! JSONSerialization.data(withJSONObject: data[0].dictionaryRepresentation(), options: [])
        let request = putAPIHeaderData(url: "settings/savemorning", body: body)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.delegate?.didSaveSunriseDataUpdate() // Let the View controller know to update screen
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
}





