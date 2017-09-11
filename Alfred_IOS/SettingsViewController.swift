//
//  SettingsViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 12/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    @IBAction func RestartAlfred(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Alfred", message:
            "Are you sure you want to restart Alfred?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            DispatchQueue.main.async {
                self.RestartAflred() // Call Alred
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func RestartAflred() {
        let AlfredBaseURL = readPlist(item: "AlfredSchedulerURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        let url = URL(string: AlfredBaseURL + "settings/restart" + AlfredAppKey)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            if error != nil {
                
                // Update the UI
                DispatchQueue.main.async() {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showError(withStatus: "Network/API connection error")
                }
            }
            
            guard let data = data, error == nil else { return }
            let json = JSON(data: data)
            let apiStatus = json["code"]
            let apiStatusString = apiStatus.string!
            
            if apiStatusString == "sucess" {
                
                // Update the UI
                DispatchQueue.main.async() {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showSuccess(withStatus: "Restarted Alfred")
                }
            } else {
                
                // Update the UI
                DispatchQueue.main.async() {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showError(withStatus: "Unable to restart Alfred")
                }
            }
        }).resume()
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
        let AlfredBaseURL = readPlist(item: "AlfredSchedulerURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        let url = URL(string: AlfredBaseURL + "settings/dellog" + AlfredAppKey)
    
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            if error != nil {
                
                // Update the UI
                DispatchQueue.main.async() {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showError(withStatus: "Unable to clear log file")
                }
            }
            
            guard let data = data, error == nil else { return }
            let json = JSON(data: data)
            let apiStatus = json["code"]
            let apiStatusString = apiStatus.string!
            
            if apiStatusString == "sucess" {

                // Update the UI
                DispatchQueue.main.async() {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showSuccess(withStatus: "Log file was cleared")
                }
            } else {
                
                // Update the UI
                DispatchQueue.main.async() {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showError(withStatus: "There was a problem clearing the flog file")
                }
            }
        }).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
