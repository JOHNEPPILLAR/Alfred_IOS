//
//  CommuteController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 09/03/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

// MARK: Delegate callback functions
protocol CommuteViewControllerDelegate: class {
    func cummuteDidRecieveDataUpdate(data: [CommuteData])
    func didFailDataUpdateWithError()
}

class CommuteController: NSObject, CLLocationManagerDelegate {
    
    weak var delegate: CommuteViewController?
    
    var locationManager:CLLocationManager!
    var whoIs:String!
    
    func getCommuteData(whoIsThis: String) {
        
        whoIs = whoIsThis
        
        // Get current location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()

        // Call Alfred API
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "travel/getcommute?user=" + whoIs + "&lat=" + "\(userLocation.coordinate.latitude)" + "&long=" + "\(userLocation.coordinate.longitude)", useScheduler: false)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = JSON(data: data!)
                let baseData = [CommuteBaseClass(json: responseJSON)] // Update data store
                let data = baseData[0].data
                self.delegate?.cummuteDidRecieveDataUpdate(data: [data!]) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError() // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.didFailDataUpdateWithError() // Let the View controller know there was an error
    }
    
}

