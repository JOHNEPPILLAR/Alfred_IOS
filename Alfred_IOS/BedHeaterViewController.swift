//
//  BedHeaterViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 03/09/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class BedHeaterViewController: UIViewController, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!) )
    }

    var bedData = [Bed]()
    
    @IBOutlet weak var masterOn: UISwitch!
    @IBAction func masterOnOff(_ sender: UISwitch) {
        if sender.isOn {
            self.bedData[0].on = "true"
        } else {
            self.bedData[0].on = "false"
        }
    }
    
    @IBOutlet weak var sideLabel: UILabel!
    @IBOutlet weak var useDI: UISwitch!
    @IBAction func useDI(_ sender: UISwitch) {
        if sender.isOn {
            self.bedData[0].useDI = "true"
        } else {
            self.bedData[0].useDI = "false"
        }
    }
    
    @IBOutlet weak var triggerTemp: UILabel!
    @IBOutlet weak var triggerStepper: UIStepper!
    @IBAction func triggerStepper(_ sender: UIStepper) {
        triggerTemp.text = Int(sender.value).description
        self.bedData[0].trigger = Int(sender.value)
    }
    
    @IBOutlet weak var tempSlider: UISlider!
    @IBAction func tempSliderValue(_ sender: UISlider) {
        for i in 0...10 {
            if let theLabel = self.view.viewWithTag(Int(i)+90) as? UILabel {
                theLabel.isHidden = true;
            }
        }
        if let theLabel = self.view.viewWithTag(Int(sender.value)+90) as? UILabel {
            theLabel.isHidden = false;
        }
        self.bedData[0].bedTemp = Int(sender.value)
    }

    @IBOutlet weak var onHR: UILabel!
    @IBOutlet weak var onHRStepper: UIStepper!
    @IBAction func onHRTrigger(_ sender: UIStepper) {
        onHR.text = Int(sender.value).description
        self.bedData[0].onHR = Int(sender.value)
    }
    
    @IBOutlet weak var onMin: UILabel!
    @IBOutlet weak var onMinStepper: UIStepper!
    @IBAction func onMinTrigger(_ sender: UIStepper) {
        onMin.text = Int(sender.value).description
        self.bedData[0].onMin = Int(sender.value)
    }
    
    @IBOutlet weak var offHR: UILabel!
    @IBOutlet weak var offHRStepper: UIStepper!
    @IBAction func offHRTrigger(_ sender: UIStepper) {
        offHR.text = Int(sender.value).description
        self.bedData[0].offHR = Int(sender.value)
    }

    @IBOutlet weak var offMin: UILabel!
    @IBOutlet weak var offMinStepper: UIStepper!
    @IBAction func ofMinTrigger(_ sender: UIStepper) {
        offMin.text = Int(sender.value).description
        self.bedData[0].offMin = Int(sender.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add save button to navigation bar
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveSettingsAction(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        
        // Disable UI controls untill data is loaded
        navigationItem.rightBarButtonItem?.isEnabled = false
        self.tempSlider.isEnabled = false
        self.triggerStepper.isEnabled = false
        self.onMinStepper.isEnabled = false
        self.offHRStepper.isEnabled = false
        self.offMinStepper.isEnabled = false
        
        // Hide all of the temp values
        for i in 0...10 {
            if let theLabel = self.view.viewWithTag(Int(i)+90) as? UILabel {
                theLabel.isHidden = true;
            }
        }
        
        // Position slider vertical
        tempSlider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        tempSlider.frame = CGRect(x: 59, y: 70, width: tempSlider.frame.size.width, height: 200)
        
        // Get configuration info from Alfred
        self.getData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop spinner
        SVProgressHUD.dismiss()
    }

    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    func getData() {
       
        // Get settings
        let request = getAPIHeaderData(url: "settings/view", useScheduler: true)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if checkAPIData(apiData: data, response: response, error: error) {
                
                // Save json to custom classes
                let json = JSON(data: data!)
                let jsonData = json["data"]["bed"]
                self.bedData = [Bed(json: jsonData)]

                // Check the defaults
                let userDefaults = UserDefaults.standard
                UserDefaults.standard.register(defaults: [String : Any]())
                let whoIsThis = userDefaults.string(forKey: "WHO_IS_THIS")
                    
                if whoIsThis == "Fran" {
                    self.bedData = [Bed(json: jsonData[1])]
                    self.sideLabel.text = "Fran's Side"
                } else {
                    self.bedData = [Bed(json: jsonData[0])]
                    self.sideLabel.text = "JP's Side"
                }
                        
                // Setup UI from settings
                if self.bedData[0].on == "true" {
                    self.masterOn.setOn(true, animated: true)
                } else {
                    self.masterOn.setOn(false, animated: true)
                }

                if self.bedData[0].useDI == "true" {
                    self.useDI.setOn(true, animated: true)
                } else {
                    self.useDI.setOn(false, animated: true)
                }
                    
                self.triggerTemp.text = String(self.bedData[0].trigger!)
                self.triggerStepper.value = Double(self.bedData[0].trigger!)
                    
                if let theLabel = self.view.viewWithTag(Int(self.bedData[0].bedTemp!)+90) as? UILabel {
                    theLabel.isHidden = false;
                }
                    
                self.onHR.text = String(self.bedData[0].onHR!)
                self.onHRStepper.value = Double(self.bedData[0].onHR!)
                self.onMin.text = String(self.bedData[0].onMin!)
                self.onMinStepper.value = Double(self.bedData[0].onMin!)
                self.offHR.text = String(self.bedData[0].offHR!)
                self.offHRStepper.value = Double(self.bedData[0].offHR!)
                self.offMin.text = String(self.bedData[0].offMin!)
                self.offMinStepper.value = Double(self.bedData[0].offMin!)
                self.tempSlider.value = Float(self.bedData[0].bedTemp!)
                    
                // Enable UI controls
                self.triggerStepper.isEnabled = true
                self.onMinStepper.isEnabled = true
                self.offHRStepper.isEnabled = true
                self.offMinStepper.isEnabled = true
                self.tempSlider.isEnabled = true
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        })
        task.resume()
    }

    @objc func saveSettingsAction(sender: UIBarButtonItem) {
        
        // Disable the save button
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            // Create post request
            let AlfredBaseURL = readPlist(item: "AlfredSchedulerURL")
            let AlfredAppKey = readPlist(item: "AlfredAppKey")
            let url = URL(string: AlfredBaseURL + "settings/savebed" + AlfredAppKey)
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try! JSONSerialization.data(withJSONObject: self.bedData[0].dictionaryRepresentation(), options: [])
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                guard let data = data, error == nil else { // Check for fundamental networking error
                    DispatchQueue.main.async {
                        // Show error
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showError(withStatus: "Network/API connection error")
                        
                        // Re enable the save button
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                    }
                    return
                }
                
                let json = JSON(data: data)
                let apiStatus = json["code"]
                let apiStatusString = apiStatus.string!
                
                if apiStatusString == "true" {
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
