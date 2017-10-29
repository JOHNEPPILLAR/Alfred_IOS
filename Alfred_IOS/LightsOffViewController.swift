//
//  LightsOffViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 15/10/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class LightsOffViewController: UIViewController, URLSessionDelegate {
    
    @IBOutlet weak var MorningOnOff: UISwitch!
    @IBAction func MorningOnOffAction(_ sender: UISwitch) {
        if sender.isOn {
            self.lightsOffData[0].morning!.masterOn = "true"
        } else {
            self.lightsOffData[0].morning!.masterOn = "false"
        }
    }
    @IBOutlet weak var MorningHrStep: UIStepper!
    @IBAction func MorningHrStepper(_ sender: UIStepper) {
        MorningHr.text = Int(sender.value).description
        lightsOffData[0].morning!.offHr = Int(sender.value)
    }
    @IBOutlet weak var MorningHr: UILabel!
    @IBOutlet weak var MorningMinStep: UIStepper!
    @IBAction func MorningMinStepper(_ sender: UIStepper) {
        MorningMin.text = Int(sender.value).description
        lightsOffData[0].morning!.offMin = Int(sender.value)
    }
    @IBOutlet weak var MorningMin: UILabel!
    @IBOutlet weak var EveningOnOff: UISwitch!
    @IBAction func EveningOnOffAction(_ sender: UISwitch) {
        if sender.isOn {
            self.lightsOffData[0].evening!.masterOn = "true"
        } else {
            self.lightsOffData[0].evening!.masterOn = "false"
        }
    }
    @IBOutlet weak var EveningHrStep: UIStepper!
    @IBAction func EveningHrStepper(_ sender: UIStepper) {
        EveningHr.text = Int(sender.value).description
        lightsOffData[0].evening!.offHr = Int(sender.value)
    }
    @IBOutlet weak var EveningHr: UILabel!
    @IBOutlet weak var EveningMinStep: UIStepper!
    @IBAction func EveningMinStepper(_ sender: UIStepper) {
        EveningMin.text = Int(sender.value).description
        lightsOffData[0].evening!.offMin = Int(sender.value)
    }
    @IBOutlet weak var EveningMin: UILabel!
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!) )
    }
    
    var lightsOffData = [LightsOff]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add save button to navigation bar
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveSettingsAction(sender:)))
        navigationItem.rightBarButtonItem = saveButton
     
        // Disable UI controls untill data is loaded
        navigationItem.rightBarButtonItem?.isEnabled = false
        self.MorningOnOff.isEnabled = false
        self.MorningHrStep.isEnabled = false
        self.MorningMinStep.isEnabled = false
        self.EveningHrStep.isEnabled = false
        self.EveningMinStep.isEnabled = false
        
        // Get configuration info from Alfred
        self.getData()
        
    }

    func getData() {
        
        // Get settings
        let request = getAPIHeaderData(url: "settings/view", useScheduler: true)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                
                // Save json to custom classes
                let json = JSON(data: data!)
                let jsonData = json["data"]["off"]
                self.lightsOffData = [LightsOff(json: jsonData)]
                DispatchQueue.main.async {
                    // Setup the offset and off timer settings
                    if self.lightsOffData[0].morning?.masterOn == "true" {
                        self.MorningOnOff.setOn(true, animated: true)
                    } else {
                        self.MorningOnOff.setOn(false, animated: true)
                    }
                    self.MorningHrStep.value = Double((self.lightsOffData[0].morning!.offHr)!)
                    self.MorningHr.text = "\(self.lightsOffData[0].morning!.offHr!)"
                    self.MorningMinStep.value = Double((self.lightsOffData[0].morning!.offMin)!)
                    self.MorningMin.text = "\(self.lightsOffData[0].morning!.offMin!)"

                    self.EveningHrStep.value = Double((self.lightsOffData[0].evening!.offHr)!)
                    self.EveningHr.text = "\(self.lightsOffData[0].evening!.offHr!)"
                    self.EveningMinStep.value = Double((self.lightsOffData[0].evening!.offMin)!)
                    self.EveningMin.text = "\(self.lightsOffData[0].evening!.offMin!)"

                    // Enable UI controls
                    self.MorningOnOff.isEnabled = true
                    self.MorningHrStep.isEnabled = true
                    self.MorningMinStep.isEnabled = true
                    self.EveningHrStep.isEnabled = true
                    self.EveningMinStep.isEnabled = true
                    
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    
                }
            }
        })
        task.resume()
    }

    @objc func saveSettingsAction(sender: UIBarButtonItem) {
        
        // Disable the save button
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // Call API
        let APIbody: Data = try! JSONSerialization.data(withJSONObject: self.lightsOffData[0].dictionaryRepresentation(), options: [])
        let request = putAPIHeaderData(url: "settings/savelightsoff", body: APIbody, useScheduler: true)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showSuccess(withStatus: "Saved")
                }
            } else {
                DispatchQueue.main.async {
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.showError(withStatus: "Unable to save settings")
                }
            }
            
            // Re enable the save button
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        })
        task.resume()
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

}
