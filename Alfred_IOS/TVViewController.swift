//
//  TVViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 30/08/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class TVViewController: UIViewController, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!) )
    }

    @IBAction func TV_off(_ sender: Any) {
    
        // Show busy acivity
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Connecting")

        DispatchQueue.global(qos: .userInitiated).async {

            // Call Alfred
            let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
            let AlfredAppKey = readPlist(item: "AlfredAppKey")
            let url = URL(string: AlfredBaseURL + "tv/turnoff" + AlfredAppKey)!
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
            let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                guard let data = data, error == nil else { // Check for fundamental networking error
                    
                    DispatchQueue.main.async {
                        // Stop busy acivity
                        SVProgressHUD.dismiss()

                        // Show error
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showError(withStatus: "Network/API connection error")
                    }
                    return
                }
           
                let json = JSON(data: data)
                let apiStatus = json["code"]
                let apiStatusString = apiStatus.string!
                
                if apiStatusString == "true" {
                    DispatchQueue.main.async {
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showSuccess(withStatus: "Turned off TV")
                    }
                } else {
                    DispatchQueue.main.async {
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showError(withStatus: "Unable to turn off TV")
                    }
                }
            })
            task.resume()
        }
    }
    
    @IBAction func Fire_tv(_ sender: Any) {

        // Show busy acivity
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Connecting")

        DispatchQueue.global(qos: .userInitiated).async {

            // Call Alfred
            let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
            let AlfredAppKey = readPlist(item: "AlfredAppKey")
            let url = URL(string: AlfredBaseURL + "tv/watchfiretv" + AlfredAppKey)!
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
            let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                guard let data = data, error == nil else { // Check for fundamental networking error
                    
                    DispatchQueue.main.async {
                        // Stop busy acivity
                        SVProgressHUD.dismiss()
                        
                        // Show error
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showError(withStatus: "Network/API connection error")
                    }
                    return
                }

                let json = JSON(data: data)
                let apiStatus = json["code"]
                let apiStatusString = apiStatus.string!
                
                if apiStatusString == "true" {
                    DispatchQueue.main.async {
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showSuccess(withStatus: "Turned on Fire TV")
                    }
                } else {
                    DispatchQueue.main.async {
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showError(withStatus: "Unable to turn off Fire TV")
                    }
                }
            })
            task.resume()
        }
    }
    
    @IBAction func Virgin_tv(_ sender: Any) {

        // Show busy acivity
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Connecting")

        DispatchQueue.global(qos: .userInitiated).async {

            // Call Alfred
            let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
            let AlfredAppKey = readPlist(item: "AlfredAppKey")
            let url = URL(string: AlfredBaseURL + "tv/watchvirgintv" + AlfredAppKey)!
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
            let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                guard let data = data, error == nil else { // Check for fundamental networking error
                 
                    DispatchQueue.main.async {

                        // Stop busy acivity
                        SVProgressHUD.dismiss()
                        
                        // Show error
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showError(withStatus: "Network/API connection error")
                    }
                    return
                }

                let json = JSON(data: data)
                let apiStatus = json["code"]
                let apiStatusString = apiStatus.string!
                
                if apiStatusString == "true" {
                    DispatchQueue.main.async {
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showSuccess(withStatus: "Turned on Virgin TV")
                    }
                } else {
                    DispatchQueue.main.async {
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showError(withStatus: "Unable to turn off Virgin TV")
                    }
                }
            })
            task.resume()
        }
    }
    
    @IBAction func Apple_tv(_ sender: Any) {
        
        // Show busy acivity
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Connecting")

        DispatchQueue.global(qos: .userInitiated).async {
            
            // Call Alfred
            let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
            let AlfredAppKey = readPlist(item: "AlfredAppKey")
            let url = URL(string: AlfredBaseURL + "tv/watchappletv" + AlfredAppKey)!
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
            let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                guard let data = data, error == nil else { // Check for fundamental networking error
                    
                    DispatchQueue.main.async {
                        // Stop busy acivity
                        SVProgressHUD.dismiss()
                        
                        // Show error
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showError(withStatus: "Network/API connection error")
                    }
                    return
                }

                let json = JSON(data: data)
                let apiStatus = json["code"]
                let apiStatusString = apiStatus.string!
                
                if apiStatusString == "true" {
                    
                    DispatchQueue.main.async {
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showSuccess(withStatus: "Turned on Apple TV")
                    }
                    
                } else {
                    
                    DispatchQueue.main.async {
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showError(withStatus: "Unable to turn off Apple TV")
                    }
                    
                }
            })
            task.resume()
        }
    }
    
    @IBAction func Playstation(_ sender: Any) {
    
        // Show busy acivity
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Connecting")

        DispatchQueue.global(qos: .userInitiated).async {

            // Call Alfred
            let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
            let AlfredAppKey = readPlist(item: "AlfredAppKey")
            let url = URL(string: AlfredBaseURL + "tv/playps4" + AlfredAppKey)!
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
            let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                guard let data = data, error == nil else { // Check for fundamental networking error
                    DispatchQueue.main.async {
                        // Stop busy acivity
                        SVProgressHUD.dismiss()
                        
                        // Show error
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showError(withStatus: "Network/API connection error")
                    }
                    return
                }

                let json = JSON(data: data)
                let apiStatus = json["code"]
                let apiStatusString = apiStatus.string!
                
                if apiStatusString == "true" {
                    DispatchQueue.main.async {
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showSuccess(withStatus: "Turned on Playstation")
                    }
                } else {
                    DispatchQueue.main.async {
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showError(withStatus: "Unable to turn off Playstation")
                    }
                }
            })
            task.resume()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop spinner
        SVProgressHUD.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
