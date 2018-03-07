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

        // Call Alfred to turn off TV
        let request = getAPIHeaderData(url: "tv/turnoff", useScheduler: false)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if !checkAPIData(apiData: data, response: response, error: error) {
                // Show error
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showError(withStatus: "Unable to turn off the TV")
                }
            } else {
                // Show sucess msg
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showSuccess(withStatus: "Turned off TV")
                }
            }
        })
        task.resume()
    }
    
    @IBAction func Fire_tv(_ sender: Any) {

        // Show busy acivity
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Connecting")

        // Call Alfred to turn on Fire TV
        let request = getAPIHeaderData(url: "tv/watchfiretv", useScheduler: false)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if !checkAPIData(apiData: data, response: response, error: error) {
                // Show error
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showError(withStatus: "Unable to turn on Fire TV")
                }
            } else {
                // Show sucess msg
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showSuccess(withStatus: "Turned on Fire TV")
                }
            }
        })
        task.resume()
    }
    
    @IBAction func Virgin_tv(_ sender: Any) {

        // Show busy acivity
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Connecting")

        // Call Alfred to turn on Virgin TV
        let request = getAPIHeaderData(url: "tv/watchvirgintv", useScheduler: false)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if !checkAPIData(apiData: data, response: response, error: error) {
                // Show error
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showError(withStatus: "Unable to turn on Virgin TV")
                }
            } else {
                // Show sucess msg
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showSuccess(withStatus: "Turned on Virgin TV")
                }
            }
        })
        task.resume()
    }
    
    @IBAction func Apple_tv(_ sender: Any) {
        
        // Show busy acivity
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Connecting")
 
        // Call Alfred to turn on Apple TV
        let request = getAPIHeaderData(url: "tv/watchappletv", useScheduler: false)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if !checkAPIData(apiData: data, response: response, error: error) {
                // Show error
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showError(withStatus: "Unable to turn on Apple TV")
                }
            } else {
                // Show sucess msg
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showSuccess(withStatus: "Turned on Apple TV")
                }
            }
        })
        task.resume()
    }
    
    @IBAction func Playstation(_ sender: Any) {
    
        // Show busy acivity
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Connecting")

        // Call Alfred to turn on PS4
        let request = getAPIHeaderData(url: "tv/playps4", useScheduler: false)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if !checkAPIData(apiData: data, response: response, error: error) {
                // Show error
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showError(withStatus: "Unable to turn on Play Station")
                }
            } else {
                // Show sucess msg
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showSuccess(withStatus: "Turned on Play Station")
                }
            }
        })
        task.resume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss() // Stop spinner
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
