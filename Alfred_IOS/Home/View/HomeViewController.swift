//
//  HomeViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 04/03/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: UIViewController {

    private let roomLightsController = RoomLightsController()
    
    // table view refresh timer
    var refreshDataTimer: Timer!
    let timerInterval = 5
    
    fileprivate var RoomLightsDataArray = [RoomLightsData]() {
        didSet {
            lightRoomsTableView?.reloadData()
        }
    }
    
    @IBOutlet weak var lightRoomsTableView: UITableView?

    // MARK: Quick Glance Tiles
    @IBAction func LightsOffPress(_ sender: UITapGestureRecognizer) {
        roomLightsController.turnOffLights()
    }

    
    // MARK: override functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")

        // Setup quick glance area
        
        // Weather Summary
        // Outside Temp
        // Commute Summary
        // Inside Temp

        // Setup lights room table
        self.lightRoomsTableView?.rowHeight = 80.0
        roomLightsController.requestData() // Get data for light rooms table view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lightRoomsTableView?.delegate = self
        lightRoomsTableView?.dataSource = self
        roomLightsController.delegate = self

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
                roomLightsController.UpdateLightBrightness(lightID: slider.tag, brightness: Int(slider.value))
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
        roomLightsController.UpdatePowerButtonValueChange(lightID: (tappedCell?.lightID.text)!, lightState: (tappedCell?.lightState.isOn)!)
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
        //let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPowerButtonPress(_:)))
        //powerButton.addGestureRecognizer(longTapRecognizer)

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomLightsDataArray.count
    }
}

extension HomeViewController: RoomLightsControllerDelegate {
    func didFailDataUpdateWithError(displayMsg: Bool) {
        if displayMsg {
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.showError(withStatus: "Unable to update the light settings")
        } else {
            if refreshDataTimer != nil {
                refreshDataTimer.invalidate() // Stop the refresh data timer
                refreshDataTimer = nil
            }
        }
    }
    
    func didRecieveDataUpdate(data: [RoomLightsData]) {
        RoomLightsDataArray = data
        SVProgressHUD.dismiss() // Stop spinner
        if refreshDataTimer == nil { // Set up data refresh timer
            refreshDataTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerInterval), repeats: true){_ in
                self.roomLightsController.requestData()
            }
        }
    }
}
