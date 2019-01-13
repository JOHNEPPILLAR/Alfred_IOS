//
//  LightsViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 16/12/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SVProgressHUD

class LightsViewController: UIViewController {
    
    private let lightsController = LightsController()
    
    @IBOutlet weak var ActivityRoomLightTableView: UIActivityIndicatorView!
    @IBOutlet weak var lightRoomView: UIScrollView!
    @IBOutlet weak var lightRoomsTableView: UITableView?

    // table view refresh timer
    var refreshDataTimer: Timer!
    let timerInterval = 5
    
    fileprivate var RoomLightsDataArray = [RoomLightsData]() {
        didSet {
            DispatchQueue.main.async {
                self.lightRoomsTableView?.reloadData()
            }
            ActivityRoomLightTableView.stopAnimating()
        }
    }
    
    @IBAction func returnToPreviousView(_ sender: UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.lightRoomsTableView?.rowHeight = UITableView.automaticDimension
        self.lightRoomsTableView?.estimatedRowHeight = 80
        
        lightsController.getLightRoomData() // Get data for light rooms table view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lightRoomsTableView?.delegate = self
        lightRoomsTableView?.dataSource = self
        lightsController.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if refreshDataTimer != nil {
            refreshDataTimer.invalidate() // Stop the refresh data timer
            refreshDataTimer = nil
        }
    }
    
    // Light room events
    @objc func lightBrightnessValueChange(slider: UISlider, event: UIEvent) {
        slider.setValue(slider.value.rounded(.down), animated: true)
        
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                if refreshDataTimer != nil {
                    refreshDataTimer.invalidate() // Stop the refresh data timer
                    refreshDataTimer = nil
                }
            case .ended:
                lightsController.UpdateLightBrightness(lightID: slider.tag, brightness: Int(slider.value))
            default:
                break
            }
        }
    }
    
    @objc func lightStateValueChange(_ sender: UISwitch) {
        if refreshDataTimer != nil {
            refreshDataTimer.invalidate() // Stop the refresh data timer
            refreshDataTimer = nil
        }
        lightsController.UpdateLightStateValueChange(lightID: (sender.tag), lightState: (sender.isOn))
    }
}

extension LightsViewController: UITableViewDelegate {
}

extension LightsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lightCell", for: indexPath) as! LightsTableViewCell
        cell.configureWithItem(item: RoomLightsDataArray[indexPath.item])
        
        // Add UI actions
        cell.brightnessSlider?.addTarget(self, action: #selector(lightBrightnessValueChange(slider:event:)), for: .valueChanged)
        cell.lightState?.addTarget(self, action: #selector(lightStateValueChange(_:)), for: .valueChanged)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomLightsDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = self.lightRoomsTableView?.cellForRow(at: indexPath) as? LightsTableViewCell
        var cellHeight = 80
        var uiViewHeight = 70
        if (cell?.lightState != nil) {
            if (!(cell?.lightState.isOn)!) {
                cellHeight = 51
                uiViewHeight = 41
            }
        } else {
        }
        cell?.cellBackgroundView.frame.size.height = CGFloat(uiViewHeight)
        return CGFloat(cellHeight)
    }
}

extension LightsViewController: LightsControllerDelegate {
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
                self.lightsController.getLightRoomData()
            }
        }
    }

}
