//
//  ViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 08/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.ping_Aflred_DI() // Make sure Alred is online
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ping_Aflred_DI() {
        
        let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        let url = URL(string: AlfredBaseURL + "ping" + AlfredAppKey)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            if error != nil {
                print ("Start up - Unable to ping Alfred")
                let alertController = UIAlertController(title: "Alfred", message:
                    "Unable to connect to Alfred. Close the app and try again.", preferredStyle: UIAlertControllerStyle.alert)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                    self.present(alertController, animated: true, completion: nil)
                })
            }
            
            guard let data = data, error == nil else { return }
            let json = JSON(data: data)
            let pingStatus = json["code"]
            let pingStatusString = pingStatus.string!
                
            if pingStatusString == "sucess" {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    self.performSegue(withIdentifier: "home", sender: self)
                })
            } else {
                print ("Start up - Ping status returned not a sucess")
                let alertController = UIAlertController(title: "Alfred", message:
                    "Unable to connect to Alfred. Close the app and try again.", preferredStyle: UIAlertControllerStyle.alert)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                    self.present(alertController, animated: true, completion: nil)
                })
            }
        }).resume()
    }
}

