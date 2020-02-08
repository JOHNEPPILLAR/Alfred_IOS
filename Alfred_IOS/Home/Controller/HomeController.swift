//
//  RoomLightsControler.swift
//  Alfred_IOS
//
//  Created by John Pillar on 04/03/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

// MARK: Delegate callback functions
protocol HomeControllerDelegate: class {
    func roomLightDidRecieveDataUpdate(data: [RoomLightsData])
    func currentWeatherDidRecieveDataUpdate(data: [CurrentWeatherData])
    func cummuteDidRecieveDataUpdate(data: [CommuteStatusData])
    func houseWeatherDidRecieveDataUpdate(data: [HouseWeatherData])
    func videoDidRecieveDataUpdate(videoUUID: String)
    func didFailDataUpdateWithError(displayMsg: Bool)
    func didFailLightDataUpdateWithError(displayMsg: Bool)
    func didFailVideoWithError()
}

class HomeController: NSObject, CLLocationManagerDelegate {
    weak var delegate: HomeControllerDelegate?
    
    func getCommutestatus() {
        // Get commute data
        let configuration = URLSessionConfiguration.ephemeral
        let request = getAPIHeaderData(url: "getcommutestatus")
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let comuteTask = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let baseData = [CommuteStatusBaseClass(json: responseJSON!)] // Update data store
                self.delegate?.cummuteDidRecieveDataUpdate(data: [baseData[0].data!]) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        comuteTask.resume()
    }
    
    func getWeather() {
        // Get current weather data
        let configuration = URLSessionConfiguration.ephemeral
        let request = getAPIHeaderData(url: "weather/today")
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let weatherTask = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [CurrentWeatherBaseData(json: responseJSON!)] // Update data store
                self.delegate?.currentWeatherDidRecieveDataUpdate(data: [data[0].data!]) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        weatherTask.resume()
        
    }
    
    func turnOffAllLights() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "alllightsoff")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.getRoomLightData()
            } else {
                self.delegate?.didFailLightDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }

    func getHouseWeatherData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "weather/house")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [HouseWeatherBaseClass(json: responseJSON!)] // Update data store
                self.delegate?.houseWeatherDidRecieveDataUpdate(data: data[0].data!) // Refresh the data and UI
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func getRoomLightData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "lightgroups")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [RoomLightsBaseData(json: responseJSON!)] // Update data store
                self.delegate?.roomLightDidRecieveDataUpdate(data: data[0].data!) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailLightDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func startVideoStream() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getHLSAPIHeaderData(url: "stream/start/Kids")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                if let APIData = responseJSON?["data"].string {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 25.0) {
                        self.delegate?.videoDidRecieveDataUpdate(videoUUID: APIData)
                    }
                } else {
                    self.delegate?.didFailVideoWithError() // Let the View controller know there was an error
                }
            } else {
                self.delegate?.didFailVideoWithError() // Let the View controller know there was an error
            }
        })
        task.resume()
    }
}
