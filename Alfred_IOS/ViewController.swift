//
//  ViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 08/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!) )
    }

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.whiteLarge
        
        self.ping_Aflred_DI() // Make sure Alred is online
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func ping_Aflred_DI() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
            let AlfredAppKey = readPlist(item: "AlfredAppKey")
            let url = URL(string: AlfredBaseURL + "ping" + AlfredAppKey)!
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
            let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                guard let data = data, error == nil else { // Check for fundamental networking error

                    let alertController = UIAlertController(title: "Alfred", message:
                        "Unable to connect to Alfred. Close the app and try again.", preferredStyle: UIAlertControllerStyle.alert)
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.present(alertController, animated: true, completion: nil)
                    }
                    return
                }

                let json = JSON(data: data)
                let pingStatus = json["code"]
                let pingStatusString = pingStatus.string!

                if pingStatusString == "sucess" {

                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                        self.activityIndicator.stopAnimating()
                        self.performSegue(withIdentifier: "home", sender: self)
                    })
                    
                } else {

                    let alertController = UIAlertController(title: "Alfred", message:
                        "Unable to connect to Alfred. Close the app and try again.", preferredStyle: UIAlertControllerStyle.alert)
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            })
            task.resume()
        }
    }
}
