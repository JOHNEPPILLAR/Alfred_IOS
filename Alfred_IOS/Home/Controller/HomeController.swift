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
    func lightRoomTableDidRecieveDataUpdate(data: [RoomLightsData])
    func currentWeatherDidRecieveDataUpdate(data: [CurrentWeatherData])
    func cummuteDidRecieveDataUpdate(data: [CommuteData])
    func insideWeatherDidRecieveDataUpdate(data: [InsideWeatherData])
    func didFailDataUpdateWithError(displayMsg: Bool)
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
        
        // Get current weather data
        var configuration = URLSessionConfiguration.ephemeral
        var body: [String: Any] = ["lat": userLocation.coordinate.latitude, "long": userLocation.coordinate.longitude]
        var APIbody: Data = try! JSONSerialization.data(withJSONObject: body, options: [])
        var request = putAPIHeaderData(url: "weather/today", body: APIbody)
        var session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        var task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [CurrentWeatherBaseData(json: responseJSON!)] // Update data store
                self.delegate?.currentWeatherDidRecieveDataUpdate(data: [data[0].data!]) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
      
        // Get commute data
        if (whoIs != "") {
            configuration = URLSessionConfiguration.ephemeral
            body = ["user": whoIs, "lat": userLocation.coordinate.latitude, "long": userLocation.coordinate.longitude ]
            APIbody = try! JSONSerialization.data(withJSONObject: body, options: [])
            request = putAPIHeaderData(url: "travel/getcommute", body: APIbody)
            session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
            task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if checkAPIData(apiData: data, response: response, error: error) {
                    let responseJSON = try? JSON(data: data!)
                    let data = [CommuteData(json: responseJSON!)] // Update data store
                    self.delegate?.cummuteDidRecieveDataUpdate(data: [data[0]]) // Let the View controller know to show the data
                } else {
                    self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
                }
            })
            task.resume()
        }
    }

    func turnOffLights() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "lights/alloff")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.getLightRoomData()
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }

    func getInsideWeatherData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "weather/inside")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [InsideWeatherBaseClass(json: responseJSON!)] // Update data store
                self.delegate?.insideWeatherDidRecieveDataUpdate(data: [data[0].data!]) // Refresh the data and UI
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    // Light room table
    func getLightRoomData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "lights/listlightgroups")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [RoomLightsBaseData(json: responseJSON!)] // Update data store
                self.delegate?.lightRoomTableDidRecieveDataUpdate(data: data[0].data!) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func UpdateLightBrightness(lightID: Int, brightness: Int) {
        let configuration = URLSessionConfiguration.ephemeral
        let body: [String: Any] = ["lightGroupNumber": lightID, "brightness": brightness]
        let APIbody: Data = try! JSONSerialization.data(withJSONObject: body, options: [])
        let request = putAPIHeaderData(url: "lights/lightgroupbrightness", body: APIbody)
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.getLightRoomData() // Get latest data and refresh UI
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func UpdateLightStateValueChange(lightID: Int, lightState: Bool) {
        var lightsStatus = "off"
        if lightState {
            lightsStatus = "on"
        }
        let configuration = URLSessionConfiguration.ephemeral
        let body: [String: Any] = ["lightGroupNumber": lightID, "lightAction": lightsStatus]        
        let APIbody: Data = try! JSONSerialization.data(withJSONObject: body, options: [])
        let request = putAPIHeaderData(url: "lights/lightgrouponoff", body: APIbody)
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.getLightRoomData() // Get latest data and refresh UI
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: true) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
}





