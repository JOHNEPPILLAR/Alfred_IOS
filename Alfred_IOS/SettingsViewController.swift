//
//  SettingsViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 12/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

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
                let alertController = UIAlertController(title: "Alfred", message:
                    "Unable to connect to Alfred. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alertController, animated: true, completion: nil)
            }
            
            guard let data = data, error == nil else { return }
            let json = JSON(data: data)
            let apiStatus = json["code"]
            let apiStatusString = apiStatus.string!
            
            if apiStatusString == "sucess" {
                let alertController = UIAlertController(title: "Alfred", message:
                    "Alfred's log file was sucesfully cleared.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Alfred", message:
                    "There was a problem clearing the flog file. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alertController, animated: true, completion: nil)
            }
        }).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
