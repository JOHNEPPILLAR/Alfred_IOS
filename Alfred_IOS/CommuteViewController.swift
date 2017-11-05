//
//  CommuteViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 04/11/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class CommuteViewController: UIViewController, URLSessionDelegate {

    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var firstTime: UILabel!
    @IBOutlet weak var firstNotes: UILabel!
    @IBOutlet weak var secondTime: UILabel!
    @IBOutlet weak var secondNotes: UILabel!
    @IBOutlet weak var tubeLine: UILabel!
    @IBOutlet weak var tubeDelays: UILabel!
    @IBOutlet weak var backupTubeLine: UILabel!
    @IBOutlet weak var backupTubeDelays: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get configuration info from Alfred
        self.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!) )
    }
    
    func getData() {
    
        // Get who is using the app
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
        let defaults = UserDefaults.standard
        let whoIsThis = defaults.string(forKey: "who_is_this")

        // Get commute information
        let request = getAPIHeaderData(url: "/travel/getcommute?user=" + whoIsThis!, useScheduler: false)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                
                let json = JSON(data: data!)
                var jsonData = json["data"]
                DispatchQueue.main.async {

                    // Update UI
                    
                    self.destination.text = jsonData["train"]["firstDestination"].string!
                    self.firstTime.text = jsonData["train"]["firstTrainTime"].string!
                    self.firstNotes.text = "( " + jsonData["train"]["firstTrainNotes"].string! + " )"
                    self.secondTime.text = jsonData["train"]["secondTrainTime"].string!
                    self.secondNotes.text = "( " + jsonData["train"]["secondTrainNotes"].string! + " )"

                    if jsonData["train"]["disruptions"].string != "false" {
                        self.destination.textColor = UIColor.red
                        self.firstTime.textColor = UIColor.red
                        self.firstNotes.textColor = UIColor.red
                        self.secondTime.textColor = UIColor.red
                        self.secondNotes.textColor = UIColor.red
                    }
                    
                    self.tubeLine.text = jsonData["tube"]["line"].string! + " line"
                    if jsonData["tube"]["disruptions"].string == "false" {
                        self.tubeDelays.text = "No delays reported"
                    } else {
                        self.tubeDelays.text = "Delays reported"
                        self.tubeDelays.textColor = UIColor.red
                        self.tubeLine.textColor = UIColor.red
                    }
                    
                    // TODO Second commute option
                }
            }
        })
        task.resume()
    }
}
