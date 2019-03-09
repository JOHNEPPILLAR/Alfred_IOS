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
    func didFailDataUpdateWithError(displayMsg: Bool)
    func didFailLightDataUpdateWithError(displayMsg: Bool)
}

class HomeController: NSObject, CLLocationManagerDelegate {
    weak var delegate: HomeControllerDelegate?
    var locationManager:CLLocationManager!
    var whoIs:String!
    
    // Get current location
    func getCurrentLocation(whoIsThis: String) {
        whoIs = whoIsThis
        // if whoIs == nil { whoIs = "JP"}

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        
        // Get commute data
        if (whoIs != "") {
            let configuration = URLSessionConfiguration.ephemeral
            let request = getAPIHeaderData(url: "commute/getcommutestatus?lat=" + "\(userLocation.coordinate.latitude)" + "&long=" + "\(userLocation.coordinate.longitude)" + "&user=" + whoIs)
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
    }

    func getWeather() {
        // Get current weather data
        let homeLat = readPlist(item: "home-lat")
        let homeLong = readPlist(item: "home-long")
        let configuration = URLSessionConfiguration.ephemeral
        let request = getAPIHeaderData(url: "weather/today?lat=" + "\(homeLat)" + "&long=" + "\(homeLong)")
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
        let request = getAPIHeaderData(url: "lights/alloff")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.getRoomLightData()
            } else {
                self.delegate?.didFailLightDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }

    func getHourseWeatherData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "weather/houseWeather")
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
        let request = getAPIHeaderData(url: "lights/listlightgroups")
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

}
