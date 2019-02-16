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
            //if refreshDataTimer != nil {
            //    refreshDataTimer.invalidate() // Stop the refresh data timer
            //    refreshDataTimer = nil
            //}
        }
    }
    
    // Process light room data
    func roomLightsDidRecieveDataUpdate(data: [RoomLightsData]) {
        let roomData = data.filter { ($0.attributes?.attributes?.id?.contains(String(roomID)))! }
        
        roomName.text = roomData[0].attributes?.attributes?.name
        //   allLightsIcon.image = #imageLiteral(resourceName: "ic_lights_off")
    }

}
