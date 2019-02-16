//
//  RoomsController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 16/02/2019.
//  Copyright © 2019 John Pillar. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

// MARK: Delegate callback functions
protocol RoomsControllerDelegate: class {
    func roomLightsDidRecieveDataUpdate(data: [RoomLightsData])
    func didFailDataUpdateWithError(displayMsg: Bool)
}

class RoomsController: NSObject {
    weak var delegate: RoomsControllerDelegate?
    
    func getLightRoomData() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "lights/listlightgroups")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = try? JSON(data: data!)
                let data = [RoomLightsBaseData(json: responseJSON!)] // Update data store
                self.delegate?.roomLightsDidRecieveDataUpdate(data: data[0].data!) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError(displayMsg: false) // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
}

