//
//  HomeViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 04/03/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SVProgressHUD
import AVKit
import AVFoundation;

class HomeViewController: UIViewController {
    
    private let homeController = HomeController()

    // table view refresh timer
    var refreshDataTimer: Timer!
    let timerInterval = 5 // seconds
    
    // MARK: Interactive elements
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var homeViewSection: UIView!
    @IBOutlet weak var livingRoomViewSection: UIView!
    @IBOutlet weak var kidsBedRoomViewSection: UIView!
    @IBOutlet weak var kidsBedRoomAirQualityIcon: UIImageView!
    @IBOutlet weak var mainBedRoomViewSection: UIView!
    @IBOutlet weak var mainBedRoomAirQualityIcon: UIImageView!
    @IBOutlet weak var kitchenViewSection: UIView!
    @IBOutlet weak var gardenViewSection: UIView!
    @IBOutlet weak var downstairsHallViewSection: UIView!
    @IBOutlet weak var middleHallViewSection: UIView!
    @IBOutlet weak var upstairsHallViewSection: UIView!

    @IBAction func AllLightsOffPress(_ sender: UILongPressGestureRecognizer) {
        homeController.turnOffAllLights()
    }

    // MARK: Info elements
    @IBOutlet weak var Greeting: UITextField!
    @IBOutlet weak var homeTemp: UITextField!
    @IBOutlet weak var homeTempMax: UITextField!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var commuteStatus: UIImageView!
    @IBOutlet weak var allLightsIcon: UIImageView!
    @IBOutlet weak var livingRoomLightsIcon: UIImageView!
    @IBOutlet weak var kidsBedRoomLightsIcon: UIImageView!
    @IBOutlet weak var kidsRoomTemp: UITextField!
    @IBOutlet weak var mainBedRoomTemp: UITextField!
    @IBOutlet weak var mainBedRoomLightsIcon: UIImageView!
    @IBOutlet weak var kitchenTemp: UITextField!
    @IBOutlet weak var kitchenLightsIcon: UIImageView!
    @IBOutlet weak var gardenTemp: UITextField!
    @IBOutlet weak var downstairsHallLightsIcon: UIImageView!
    @IBOutlet weak var middleHallLightsIcon: UIImageView!
    @IBOutlet weak var upstairsHallLightsIcon: UIImageView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "kidsRoomVideo"?:
            let destination = segue.destination as! AVPlayerViewController
            let url = URL(string: readPlist(item: "LottieCamURL"))
            if let movieURL = url {
                destination.player = AVPlayer(url: movieURL)
                destination.player?.play()
            }
        case .none:
            return
        case .some(_):
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Check the user defaults
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
        let defaults = UserDefaults.standard
        menuIcon.isHidden = true
        var whoIsThis = defaults.string(forKey: "who_is_this")
        if (whoIsThis == nil) {
            whoIsThis = ""
            SVProgressHUD.showInfo(withStatus: "Please setup the app user defaults in settings")
            commuteStatus.image = #imageLiteral(resourceName: "ic_question_mark")
        }
        if (whoIsThis == "JP") {
            menuIcon.isHidden = false
        }

        // Calc which part of day it is and set greeting message
        let hour = Calendar.current.component(.hour, from: Date())
        if (hour >= 0 && hour <= 12) {
            Greeting.text = "Good Morning " + whoIsThis!
        } else if (hour > 12 && hour <= 17) {
            Greeting.text = "Good Afternoon " + whoIsThis!
        } else {
            Greeting.text = "Good Evening " + whoIsThis!
        }

        // Call API's to get data
        homeController.getWeather()
        homeController.getLightRoomData()
        homeController.getCurrentLocation(whoIsThis: whoIsThis!)
        homeController.getHourseWeatherData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeController.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if refreshDataTimer != nil {
            refreshDataTimer.invalidate() // Stop the refresh data timer
            refreshDataTimer = nil
        }
    }
    
}

extension HomeViewController: HomeControllerDelegate {
    
    func didFailDataUpdateWithError(displayMsg: Bool) {
        if displayMsg {
            SVProgressHUD.showError(withStatus: "Network/API error")
        } else {
            if refreshDataTimer != nil {
                refreshDataTimer.invalidate() // Stop the refresh data timer
                refreshDataTimer = nil
            }
        }
    }
    
    // Process light room data
    func lightRoomDidRecieveDataUpdate(data: [RoomLightsData]) {
        allLightsIcon.image = #imageLiteral(resourceName: "ic_lights_off")
        for item in data {
            switch item.attributes?.attributes?.id {
            case "4": // Kids bed room
                kidsBedRoomLightsIcon.image = #imageLiteral(resourceName: "ic_lights_off")
                if (item.state?.attributes?.anyOn)! {
                    allLightsIcon.image = #imageLiteral(resourceName: "ic_lights_on")
                    kidsBedRoomLightsIcon.image = #imageLiteral(resourceName: "ic_lights_on")
                }
            case "5": // main bed room
                mainBedRoomLightsIcon.image = #imageLiteral(resourceName: "ic_lights_off")
                if (item.state?.attributes?.anyOn)! {
                    allLightsIcon.image = #imageLiteral(resourceName: "ic_lights_on")
                    mainBedRoomLightsIcon.image = #imageLiteral(resourceName: "ic_lights_on")
                }
            case "8": // living room
                livingRoomLightsIcon.image = #imageLiteral(resourceName: "ic_lights_off")
                if (item.state?.attributes?.anyOn)! {
                    allLightsIcon.image = #imageLiteral(resourceName: "ic_lights_on")
                    livingRoomLightsIcon.image = #imageLiteral(resourceName: "ic_lights_on")
                }
            case "9": // kitchen
                kitchenLightsIcon.image = #imageLiteral(resourceName: "ic_lights_off")
                if (item.state?.attributes?.anyOn)! {
                    allLightsIcon.image = #imageLiteral(resourceName: "ic_lights_on")
                    kitchenLightsIcon.image = #imageLiteral(resourceName: "ic_lights_on")
                }
            case "7": // Downstairs Hall
                downstairsHallLightsIcon.image = #imageLiteral(resourceName: "ic_lights_off")
                if (item.state?.attributes?.anyOn)! {
                    allLightsIcon.image = #imageLiteral(resourceName: "ic_lights_on")
                    downstairsHallLightsIcon.image = #imageLiteral(resourceName: "ic_lights_on")
                }
            case "6": // Middle Hall
                middleHallLightsIcon.image = #imageLiteral(resourceName: "ic_lights_off")
                if (item.state?.attributes?.anyOn)! {
                    allLightsIcon.image = #imageLiteral(resourceName: "ic_lights_on")
                    middleHallLightsIcon.image = #imageLiteral(resourceName: "ic_lights_on")
                }
            case "10": // Upstairs Hall
                upstairsHallLightsIcon.image = #imageLiteral(resourceName: "ic_lights_off")
                if (item.state?.attributes?.anyOn)! {
                    allLightsIcon.image = #imageLiteral(resourceName: "ic_lights_on")
                    upstairsHallLightsIcon.image = #imageLiteral(resourceName: "ic_lights_on")
                }
            default: break
            }
        }
        
        if refreshDataTimer == nil { // Set up data refresh timer
            refreshDataTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerInterval), repeats: true){_ in
                self.homeController.getLightRoomData()
            }
        }
    }
    
    func currentWeatherDidRecieveDataUpdate(data: [CurrentWeatherData]) {
        switch data[0].icon {
        case "clear-day"?: weatherIcon.image = #imageLiteral(resourceName: "ic_Weather-clear-day")
        case "clear-night"?: weatherIcon.image = #imageLiteral(resourceName: "ic_Weather-clear-night")
        case "rain"?: weatherIcon.image = #imageLiteral(resourceName: "ic_Weather-rain")
        case "snow"?: weatherIcon.image = #imageLiteral(resourceName: "ic_Weather-snow")
        case "sleet"?: weatherIcon.image = #imageLiteral(resourceName: "ic_Weather-snow")
        case "wind"?: weatherIcon.image = #imageLiteral(resourceName: "ic_Weather-wind")
        case "fog"?: weatherIcon.image = #imageLiteral(resourceName: "ic_Weather-unknown")
        case "cloudy"?: weatherIcon.image = #imageLiteral(resourceName: "ic_Weather-cloudy")
        case "partly-cloudy-day"?: weatherIcon.image = #imageLiteral(resourceName: "ic_Weather-cloudy-day")
        case "partly-cloudy-night"?: weatherIcon.image = #imageLiteral(resourceName: "ic_Weather-partly-cloudy-night")
        case .none: weatherIcon.image = #imageLiteral(resourceName: "ic_Weather-unknown")
        case .some(_): weatherIcon.image = nil
        }
        DispatchQueue.main.async {
            self.homeTemp.text = "\(data[0].temperature ?? 0)"
            self.homeTempMax.text = "Max \(data[0].temperatureHigh ?? 0)"
        }
    }
    
    func cummuteDidRecieveDataUpdate(data: [CommuteStatusData]) {
        DispatchQueue.main.async {
            if (data[0].anyDisruptions!) {
                self.commuteStatus.image = #imageLiteral(resourceName: "ic_transport_error")
            } else {
                self.commuteStatus.image = #imageLiteral(resourceName: "ic_transport_ok")
            }
        }
    }
    
    func houseWeatherDidRecieveDataUpdate(data: [HouseWeatherData]) {
        DispatchQueue.main.async {
            // Kids room
            self.kidsRoomTemp.text = "\(data[0].kidsRoom?.temperature ?? 0)"
            self.kidsBedRoomAirQualityIcon.image = #imageLiteral(resourceName: "ic_circle_green")
            if data[0].kidsRoom?.cO2 ?? 0 > 1150 {
                self.kidsBedRoomAirQualityIcon.image = #imageLiteral(resourceName: "ic_circle_yellow")
            }
            if data[0].kidsRoom?.cO2 ?? 0 > 1400 {
                self.kidsBedRoomAirQualityIcon.image = #imageLiteral(resourceName: "ic_circle_red")
            }
            
            // Main bed room
            self.mainBedRoomTemp.text = "\(data[0].mainBedRoom?.temperature ?? 0)"
            switch data[0].mainBedRoom?.airQuality {
                case 2: self.mainBedRoomAirQualityIcon.image = #imageLiteral(resourceName: "ic_circle_green")
                case 3: self.mainBedRoomAirQualityIcon.image = #imageLiteral(resourceName: "ic_circle_yellow")
                case 4: self.mainBedRoomAirQualityIcon.image = #imageLiteral(resourceName: "ic_circle_red")
            case .none:
                self.mainBedRoomAirQualityIcon.image = nil
            case .some(_):
                self.mainBedRoomAirQualityIcon.image = nil
            }

            // Kitchen room
            self.kitchenTemp.text = "\(data[0].kitchen?.temperature ?? 0)"

            // Garden room
            self.gardenTemp.text = "\(data[0].garden?.temperature ?? 0)"
        }
    }
    
}
