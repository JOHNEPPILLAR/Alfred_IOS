//
//  ViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 08/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //let app_key = "631dd7b4-62bf-4dbe-93be-7eef30922bc4";
    var ping_URL = "http://johneppillar.synology.me:3978/ping?app_key=631dd7b4-62bf-4dbe-93be-7eef30922bc4";
    
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
        let url = URL(string: ping_URL)
        
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
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                
                let pingStatus = jsonObj["data"] as? String
                
                if pingStatus == "sucess." {
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
            } catch {
                print(error)
                let alertController = UIAlertController(title: "Alfred", message:
                        error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                self.present(alertController, animated: true, completion: nil)
            }
        }).resume()
    }
}

