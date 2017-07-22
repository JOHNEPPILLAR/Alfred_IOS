//
//  SettingsViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 12/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import BRYXBanner

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func DelLogFileTap(_ sender: UITapGestureRecognizer) {

        let alertController = UIAlertController(title: "Alfred", message:
            "Are you sure you want to clear the log file?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            DispatchQueue.main.async {
                self.DelAflredLog() // Call Alred
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func DelAflredLog() {
        let AlfredBaseURL = Bundle.main.infoDictionary!["AlfredBaseURL"] as! String
        let AlfredAppKey = Bundle.main.infoDictionary!["AlfredAppKey"] as! String
        let url = URL(string: AlfredBaseURL + "ping" + AlfredAppKey)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            if error != nil {
                
                // Update the UI
                DispatchQueue.main.async() {
                    
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to clear log file data", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                }
            }
            
            guard let data = data, error == nil else { return }
            let json = JSON(data: data)
            let apiStatus = json["code"]
            let apiStatusString = apiStatus.string!
            
            if apiStatusString == "sucess" {

                // Update the UI
                DispatchQueue.main.async() {
                    
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Alfred's log file was sucesfully cleared.", backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show(duration: 3.0)
                    
                }
            } else {
                
                // Update the UI
                DispatchQueue.main.async() {
                    
                    let banner = Banner(title: "Alfred API Notification", subtitle: "There was a problem clearing the flog file. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                    
                }
            }
        }).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
