//
//  CommuteController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 09/03/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: Delegate callback functions
protocol VideoControllerDelegate: class {
    func reStartDidRecieveDataUpdate()
    func didFailDataUpdateWithError()
}

class VideoController: NSObject {
    
    weak var delegate: VideoControllerDelegate?
    
    func reStartStreams() {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getHLSAPIHeaderData(url: "restart")
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                self.delegate?.reStartDidRecieveDataUpdate()
            } else {
                self.delegate?.didFailDataUpdateWithError() // Let the View controller know there was an error
            }
        })
        task.resume()
    }
}

