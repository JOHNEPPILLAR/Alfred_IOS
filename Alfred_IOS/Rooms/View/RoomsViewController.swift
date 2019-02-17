//
//  RoomsViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 20/01/2019.
//  Copyright © 2019 John Pillar. All rights reserved.
//

import UIKit
import SVProgressHUD

class RoomsViewController: UIViewController {

    private let roomsController = RoomsController()

    let timerInterval = 5 // seconds
    var refreshDataTimer: Timer!
    var roomID:Int = 0
    
    @IBAction func returnToPreviousView(_ sender: UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    
    
    @IBOutlet weak var roomName: UILabel!
    
    // Lights
    @IBOutlet weak var lightsLabel: UITextField!
    @IBOutlet weak var lightsLabelLine: UIView!
    
    @IBOutlet weak var lightsOnOff: UISwitch!
    @IBOutlet weak var lightsView: UIView!
    @IBOutlet weak var lightSlider: UISlider!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Call API's to get data
        roomsController.getLightRoomData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomsController.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if refreshDataTimer != nil {
            refreshDataTimer.invalidate() // Stop the refresh data timer
            refreshDataTimer = nil
        }
    }
}

extension RoomsViewController: RoomsControllerDelegate {
        
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
    func roomLightsDidRecieveDataUpdate(data: [RoomLightsData]) {
        let roomData = data.filter { ($0.attributes?.attributes?.id?.contains(String(roomID)))! }
        
        roomName.text = roomData[0].attributes?.attributes?.name
        
        lightsOnOff.isOn = roomData[0].state?.attributes?.anyOn ?? false
        lightSlider.value = Float(roomData[0].action?.attributes?.bri ?? 0)
        
        var color = UIColor(red: 30/255, green: 34/255, blue: 60/255, alpha: 0.5)
        if (roomData[0].state?.attributes?.anyOn)! {
            switch roomData[0].action?.attributes?.colormode {
            case "ct"?: color = HueColorHelper.getColorFromScene((roomData[0].action?.attributes?.ct)!)
            case "xy"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((roomData[0].action?.attributes?.xy![0])!), y: Double((roomData[0].action?.attributes?.xy![1])!)), forModel: "LCT007")
            case "hs"?: color = HueColorHelper.colorFromXY(CGPoint(x: Double((roomData[0].action?.attributes?.xy![0])!), y: Double((roomData[0].action?.attributes?.xy![1])!)), forModel: "LCT007")
            default: color = UIColor.white
            }
            let darkerColor = color.darker(by: -15)
            lightsOnOff.onTintColor = darkerColor
            lightSlider.maximumTrackTintColor = darkerColor
            lightSlider.setMinimumTrackImage(startColor: darkerColor!,
                                                  endColor: UIColor.white,
                                                  startPoint: CGPoint.init(x: 0, y: 0),
                                                  endPoint: CGPoint.init(x: 1, y: 1))
            // lightSlider.layer.cornerRadius = 12.0;
            lightSlider.isHidden = false
            lightsView.backgroundColor = color
            
        } else {
            lightSlider.isHidden = true
        }
        
        if refreshDataTimer == nil { // Set up data refresh timer
            refreshDataTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerInterval), repeats: true){_ in
                self.roomsController.getLightRoomData()
            }
        }

    }

}
