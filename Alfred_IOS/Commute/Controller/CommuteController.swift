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
protocol CommuteViewControllerDelegate: class {
    func cummuteDidRecieveDataUpdate(data: [CommuteData])
    func didFailDataUpdateWithError()
}

class CommuteController: NSObject {
    
    weak var delegate: CommuteViewController?
    
    func getCommuteData(whiIsThis: String) {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = getAPIHeaderData(url: "travel/getcommute?user=" + whiIsThis, useScheduler: false)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                let responseJSON = JSON(data: data!)
                let data = [CommuteBaseData(json: responseJSON)] // Update data store
                self.delegate?.cummuteDidRecieveDataUpdate(data: [data[0].data!]) // Let the View controller know to show the data
            } else {
                self.delegate?.didFailDataUpdateWithError() // Let the View controller know there was an error
            }
        })
        task.resume()
    }
    
}

