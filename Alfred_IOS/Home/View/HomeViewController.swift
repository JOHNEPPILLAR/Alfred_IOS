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

class HomeViewController: UIViewController, UIScrollViewDelegate {

    private let homeController = HomeController()
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var lightRoomView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBAction func pageChange(_ sender: UIPageControl) {
        if (sender.currentPage == 0) {
            videoView.isHidden = true
            lightRoomView.isHidden = false
        }
        if (sender.currentPage == 1) {
            videoView.isHidden = false
            lightRoomView.isHidden = true
        }
    }
    
    // table view refresh timer
    var refreshDataTimer: Timer!
    let timerInterval = 5
    
    // Request data status
    var currentWeatherDone = false
    var commuteDone = false
    var lightRoomTableViewDone = false
    var inSideTempDone = false
    
    fileprivate var RoomLightsDataArray = [RoomLightsData]() {
        didSet {
            lightRoomsTableView?.reloadData()
            stopLoadingMessage(caller: "lightRoomTableViewDone")
        }
    }
    
    @IBOutlet weak var lightRoomsTableView: UITableView?

    // MARK: Quick Glance Tiles
    @IBOutlet weak var Greeting: UITextField!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var outSideTemp: UITextField!
    @IBOutlet weak var outSideTempMax: UITextField!
    @IBOutlet weak var commuteStatus: UIImageView!
    @IBAction func LightsOffPress(_ sender: UITapGestureRecognizer) {
        homeController.turnOffLights()
    }
    @IBOutlet weak var inSideTemp: UITextField!
    
    // MARK: override functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "lottieVideo"?:
            let destination = segue.destination as! AVPlayerViewController
            let url = URL(string: readPlist(item: "LottieCamURL"))
            if let movieURL = url {
                destination.player = AVPlayer(url: movieURL)
            }
        case "harrietVideo"?:
            let destination = segue.destination as! AVPlayerViewController
            let url = URL(string: readPlist(item: "HarrietCamURL"))
            if let movieURL = url {
                destination.player = AVPlayer(url: movieURL)
            }
        case .none:
            return
        case .some(_):
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")

        // Setup quick glance area
        
        // Check the user defaults
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
        let defaults = UserDefaults.standard
        var whoIsThis = defaults.string(forKey: "who_is_this")
        if (whoIsThis == nil){
            whoIsThis = ""
            SVProgressHUD.showInfo(withStatus: "Please setup the app user defaults in settings")
        } else {
            homeController.getCommuteData(whiIsThis: whoIsThis!) // Commute Summary
        }

        // Calc which part of day it is and set greeting message
        let hour = Calendar.current.component(.hour, from: Date())
        if (hour >= 0 && hour <= 12) {
            Greeting.text = "Good Morning " + whoIsThis!;
        } else if (hour > 12 && hour <= 17) {
            Greeting.text = "Good Afternoon " + whoIsThis!;
        } else {
            Greeting.text = "Good Evening " + whoIsThis!;
        }

        homeController.getCurrentWeatherData() // Weather Summary

        // ** TODO **
        // Inside Temp

        // Setup feature area
        videoView.isHidden = true
        lightRoomView.isHidden = false

        // Setup lights room table
        self.lightRoomsTableView?.rowHeight = 80.0
        homeController.getLightRoomData() // Get data for light rooms table view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        lightRoomsTableView?.delegate = self
        lightRoomsTableView?.dataSource = self
        homeController.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss() // Stop spinner
        if refreshDataTimer != nil {
            refreshDataTimer.invalidate() // Stop the refresh data timer
            refreshDataTimer = nil
        }
    }
    
    // Light room events
    @objc func lightbrightnessValueChange(slider: UISlider, event: UIEvent) {
        slider.setValue(slider.value.rounded(.down), animated: true)
       
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                if refreshDataTimer != nil {
                    refreshDataTimer.invalidate() // Stop the refresh data timer
                    refreshDataTimer = nil
                }
            case .ended:
                homeController.UpdateLightBrightness(lightID: slider.tag, brightness: Int(slider.value))
            default:
                break
            }
        }
    }
    
    @objc func lightPowerButtonValueChange(_ sender: UITapGestureRecognizer!) {
        if refreshDataTimer != nil {
            refreshDataTimer.invalidate() // Stop the refresh data timer
            refreshDataTimer = nil
        }
        
        // Find out tapped cell
        let tapLocation = sender.location(in: self.lightRoomsTableView)
        let tapIndexPath = self.lightRoomsTableView?.indexPathForRow(at: tapLocation)
        let tappedCell = self.lightRoomsTableView?.cellForRow(at: tapIndexPath!) as? LightsTableViewCell
        homeController.UpdatePowerButtonValueChange(lightID: (tappedCell?.lightID.text)!, lightState: (tappedCell?.lightState.isOn)!)
    }
}

extension HomeViewController: UITableViewDelegate {
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lightCell", for: indexPath) as! LightsTableViewCell
        cell.configureWithItem(item: RoomLightsDataArray[indexPath.item])
        
        // Add UI actions
        cell.brightnessSlider?.addTarget(self, action: #selector(lightbrightnessValueChange(slider:event:)), for: .valueChanged)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(lightPowerButtonValueChange(_:)))
        cell.powerButton?.addGestureRecognizer(tapRecognizer)

        // ** TODO **
        //let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPowerButtonPress(_:)))
        //powerButton.addGestureRecognizer(longTapRecognizer)

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomLightsDataArray.count
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
    
    // Light room table callback function
    func lightRoomTableDidRecieveDataUpdate(data: [RoomLightsData]) {
        RoomLightsDataArray = data
        if refreshDataTimer == nil { // Set up data refresh timer
            refreshDataTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerInterval), repeats: true){_ in
                self.homeController.getLightRoomData()
            }
        }
    }
    
    func currentWeatherDidRecieveDataUpdate(data: [CurrentWeatherData]) {
        switch data[0].icon {
            case "clear-day"?: weatherIcon.image = #imageLiteral(resourceName: "Weather-clear-day")
            case "clear-night"?: weatherIcon.image = #imageLiteral(resourceName: "Weather-clear-night")
            case "rain"?: weatherIcon.image = #imageLiteral(resourceName: "Weather-rain")
            case "snow"?: weatherIcon.image = #imageLiteral(resourceName: "Weather-snow")
            case "sleet"?: weatherIcon.image = #imageLiteral(resourceName: "Weather-snow")
            case "wind"?: weatherIcon.image = #imageLiteral(resourceName: "Weather-wind")
            case "fog"?: weatherIcon.image = nil
            case "cloudy"?: weatherIcon.image = #imageLiteral(resourceName: "Weather-cloudy")
            case "partly-cloudy-day"?: weatherIcon.image = #imageLiteral(resourceName: "Weather-cloudy-day")
            case "partly-cloudy-night"?: weatherIcon.image = #imageLiteral(resourceName: "Weather-partly-cloudy-night")
            case .none: weatherIcon.image = #imageLiteral(resourceName: "Weather-unknown")
            case .some(_): weatherIcon.image = nil
        }
        outSideTemp.text = "\(data[0].temperature ?? 0)"
        outSideTempMax.text = "Max \(data[0].temperatureHigh ?? 0)"
        stopLoadingMessage(caller: "currentWeatherDone")
    }

    func cummuteDidRecieveDataUpdate(data: [CommuteData]) {
        if (data[0].anyDisruptions)! {
            commuteStatus.image = #imageLiteral(resourceName: "Good")
        } else {
            commuteStatus.image = #imageLiteral(resourceName: "Bad")
        }
        stopLoadingMessage(caller: "commuteDone")
    }
    
    func stopLoadingMessage(caller: String) {
        switch caller {
            case "currentWeatherDone": currentWeatherDone = true
            case "commuteDone": commuteDone = true
            case "inSideTempDone": inSideTempDone = true
            case "lightRoomTableViewDone": lightRoomTableViewDone = true
            default: return
        }
//        if (currentWeatherDone && commuteDone && lightRoomTableViewDone && inSideTempDone) {
        if (currentWeatherDone && commuteDone && lightRoomTableViewDone) {
            SVProgressHUD.dismiss() // Stop spinner
        }
    }
    
}
