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

    @IBOutlet weak var part1Image: UIImageView!
    @IBOutlet weak var part1Line: UILabel!
    @IBOutlet weak var part1Time: UILabel!

    @IBOutlet weak var part2Image: UIImageView!
    @IBOutlet weak var part2Line: UILabel!
    @IBOutlet weak var part2Time: UILabel!

    @IBOutlet weak var part3Image: UIImageView!
    @IBOutlet weak var part3Line: UILabel!
    @IBOutlet weak var part3Time: UILabel!
    
    @IBOutlet weak var part4Image: UIImageView!
    @IBOutlet weak var part4Line: UILabel!
    @IBOutlet weak var part4Time: UILabel!
    
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
                    // First commute option
                    switch jsonData["part1"]["mode"].string! {
                    case "train"  :
                        self.part1Image.image = UIImage(named: "ic_train")
                        self.part1Line.text = jsonData["part1"]["destination"].string!
                        self.part1Time.text = jsonData["part1"]["firstTime"].string! + " - " + jsonData["part1"]["secondTime"].string!
                    case "bus"  :
                        self.part1Image.image = UIImage(named: "ic_bus")
                        self.part1Line.text = jsonData["part1"]["line"].string! + " to " + jsonData["part1"]["destination"].string!
                        self.part1Time.text = jsonData["part1"]["firstTime"].string! + " - " + jsonData["part1"]["secondTime"].string!
                    case "tube"  :
                        self.part1Image.image = UIImage(named: "ic_tube")
                        self.part1Line.text = jsonData["part1"]["line"].string! + " Line"
                        self.part1Time.text = "No disruptions"
                    default :
                        self.part1Image.image = nil
                    }
                    if jsonData["part1"]["disruptions"].string != "false" {
                        self.part1Line.textColor = UIColor.red
                        self.part1Time.textColor = UIColor.red
                        self.part1Time.text = "Disruptions"
                    }

                    // Second commute option
                    switch jsonData["part2"]["mode"].string! {
                    case "train"  :
                        self.part2Image.image = UIImage(named: "ic_train")
                        self.part2Line.text = jsonData["part2"]["destination"].string!
                        self.part2Time.text = jsonData["part2"]["firstTime"].string! + " - " + jsonData["part2"]["secondTime"].string!
                    case "bus"  :
                        self.part2Image.image = UIImage(named: "ic_bus")
                        self.part2Line.text = jsonData["part2"]["line"].string! + " to " + jsonData["part2"]["destination"].string!
                        self.part2Time.text = jsonData["part2"]["firstTime"].string! + " - " + jsonData["part2"]["secondTime"].string!
                    case "tube"  :
                        self.part2Image.image = UIImage(named: "ic_tube")
                        self.part2Line.text = jsonData["part2"]["line"].string! + " Line"
                        self.part2Time.text = "No disruptions"
                    default :
                        self.part2Image.image = nil
                    }
                    if jsonData["part2"]["disruptions"].string != "false" {
                        self.part2Line.textColor = UIColor.red
                        self.part2Time.textColor = UIColor.red
                        self.part2Time.text = "Disruptions"
                    }

                    // Third commute option
                    switch jsonData["part3"]["mode"].string! {
                    case "train"  :
                        self.part3Image.image = UIImage(named: "ic_train")
                        self.part3Line.text = jsonData["part3"]["destination"].string!
                        self.part3Time.text = jsonData["part3"]["firstTime"].string! + " - " + jsonData["part3"]["secondTime"].string!
                    case "bus"  :
                        self.part3Image.image = UIImage(named: "ic_bus")
                        self.part3Line.text = jsonData["part3"]["line"].string! + " to " + jsonData["part3"]["destination"].string!
                        self.part3Time.text = jsonData["part3"]["firstTime"].string! + " - " + jsonData["part3"]["secondTime"].string!
                    case "tube"  :
                        self.part3Image.image = UIImage(named: "ic_tube")
                        self.part3Line.text = jsonData["part3"]["line"].string! + " Line"
                        self.part3Time.text = "No disruptions"
                    default :
                        self.part3Image.image = nil
                    }
                    if jsonData["part3"]["disruptions"].string != "false" {
                        self.part3Line.textColor = UIColor.red
                        self.part3Time.textColor = UIColor.red
                        self.part3Time.text = "Disruptions"
                    }

                    // Forth commute option
                    switch jsonData["part4"]["mode"].string! {
                    case "train"  :
                        self.part4Image.image = UIImage(named: "ic_train")
                        self.part4Line.text = jsonData["part4"]["destination"].string!
                        self.part4Time.text = jsonData["part4"]["firstTime"].string! + " - " + jsonData["part4"]["secondTime"].string!
                    case "bus"  :
                        self.part4Image.image = UIImage(named: "ic_bus")
                        self.part4Line.text = jsonData["part4"]["line"].string! + " to " + jsonData["part4"]["destination"].string!
                        self.part4Time.text = jsonData["part4"]["firstTime"].string! + " - " + jsonData["part4"]["secondTime"].string!
                    case "tube"  :
                        self.part4Image.image = UIImage(named: "ic_tube")
                        self.part4Line.text = jsonData["part4"]["line"].string! + " Line"
                        self.part4Time.text = "No disruptions"
                    default :
                        self.part4Image.image = nil
                    }
                    if jsonData["part4"]["disruptions"].string != "false" {
                        self.part4Line.textColor = UIColor.red
                        self.part4Time.textColor = UIColor.red
                        self.part4Time.text = "Disruptions"
                    }
                }
            }
        })
        task.resume()
    }
}
