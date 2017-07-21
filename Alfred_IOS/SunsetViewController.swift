//
//  SunsetViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 14/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit

class SunsetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var lightData = [LightData]()
    
    @IBOutlet weak var LightTableView: UITableView!
    
    @IBOutlet weak var offsetHRLabel: UILabel!
    @IBOutlet weak var offsetHRStepper: UIStepper!
    @IBAction func offsetHRStepper(_ sender: UIStepper) {
        offsetHRLabel.text = Int(sender.value).description
    }
    
    @IBOutlet weak var offsetMINLabel: UILabel!
    @IBOutlet weak var offsetMINStepper: UIStepper!
    @IBAction func offsetMINStepper(_ sender: UIStepper) {
        offsetMINLabel.text = Int(sender.value).description
    }
    
    @IBOutlet weak var turnoffHRLabel: UILabel!
    @IBOutlet weak var turnoffHRStepper: UIStepper!
    @IBAction func turnoffHRStepper(_ sender: UIStepper) {
        turnoffHRLabel.text = Int(sender.value).description
    }
    
    @IBOutlet weak var turnoffMINLabel: UILabel!
    @IBOutlet weak var turnoffMINStepper: UIStepper!
    @IBAction func turnoffMINStepper(_ sender: UIStepper) {
        turnoffMINLabel.text = Int(sender.value).description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add save button to navigation bar
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveSettingsAction(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        
        self.getLogData() // Get sunset configuration info from Alfred
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Private Methods
    func getLogData() {
        
        let AlfredBaseURL = Bundle.main.infoDictionary!["AlfredBaseURL"] as! String
        let AlfredAppKey = Bundle.main.infoDictionary!["AlfredAppKey"] as! String
        let url = URL(string: AlfredBaseURL + "settings" + AlfredAppKey)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            if error != nil {
                print ("Sunset - Unable to get data")
                let alertController = UIAlertController(title: "Alfred", message:
                    "Unable to retrieve settings. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alertController, animated: true, completion: nil)
            } else {
                guard let data = data, error == nil else { return }
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    let apiStatus = jsonObj?["code"] as? String
                    if apiStatus == "sucess" {
                        
                        DispatchQueue.main.async() {
                            
                            let apiData = jsonObj?["data"] as! [String: Any]
                            let eveningData = apiData["evening"] as! [String: Any]
                            
                            // Setup the offset and off timer settings
                            self.offsetHRLabel.text = String(eveningData["offset_hr"] as! Int)
                            self.offsetHRStepper.value = Double(eveningData["offset_hr"] as! Int)
                            
                            self.offsetMINLabel.text = String(eveningData["offset_min"] as! Int)
                            self.offsetMINStepper.value = Double(eveningData["off_min"] as! Int)
                            
                            self.turnoffHRLabel.text = String(eveningData["off_hr"] as! Int)
                            self.turnoffHRStepper.value = Double(eveningData["off_hr"] as! Int)
                            
                            self.turnoffMINLabel.text = String(eveningData["off_min"] as! Int)
                            self.turnoffMINStepper.value = Double(eveningData["off_min"] as! Int)
                            
                            // Setup the lights
                            let lightsData = eveningData["lights"] as! [NSDictionary]
                            for item in lightsData {
                                
                                let jsonObject: [String: Any] = [
                                    "lightID": item["lightID"]!,
                                    "lightName": item["lightName"]!,
                                    "onoff": item["onoff"]!,
                                    "brightness": item["brightness"]!,
                                    "x": item["x"]!,
                                    "y": item["y"]!,
                                    "type": item["type"]!
                                ]
                                self.lightData.append(LightData(json: jsonObject as NSDictionary))
                            }
                            
                            // Update the UI
                            DispatchQueue.main.async() {
                                self.LightTableView.reloadData() // Refresh the table view
                            }
                            
                        }
                    } else {
                        let alertController = UIAlertController(title: "Alfred", message:
                            "Unable to retrieve settings. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                        self.present(alertController, animated: true, completion: nil)
                    }
                } catch {
                    let alertController = UIAlertController(title: "Alfred", message:
                        "Unable to retrieve settings. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }).resume()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return lightData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LightTableViewCell") as! LightTableViewCell
        let row = indexPath.row
        
        cell.LightNameLabel.text = lightData[row].lightName
        if lightData[row].onoff == "on" {
            cell.onOffSwitch.setOn(true, animated:true)
        } else {
            cell.onOffSwitch.setOn(false, animated:true)
        }
        cell.LightBrightnessSlider.setValue(Float(lightData[row].brightness!), animated: true)
        cell.xLabel.text = String(describing: lightData[row].x)
        cell.yLabel.text = String(describing: lightData[row].y)
        
        return cell
    }
    
    func saveSettingsAction(sender: UIBarButtonItem)
    {
        
        //  Update table data array with UI changes
        var i = 0
        for cell in LightTableView.visibleCells {
            if let customCell = cell as? LightTableViewCell {
                if customCell.onOffSwitch.isOn {
                    lightData[i].onoff = "on"
                } else {
                    lightData[i].onoff = "off"
                }
                lightData[i].brightness = Int(customCell.LightBrightnessSlider.value)
                lightData[i].x = Double(customCell.xLabel.text!)
                lightData[i].y = Double(customCell.yLabel.text!)
            }
            i += 1
        }
        
        // Create post request
        let AlfredBaseURL = "http://localhost:3978/"
        let AlfredAppKey = Bundle.main.infoDictionary!["AlfredAppKey"] as! String
        let url = URL(string: AlfredBaseURL + "savesettings" + AlfredAppKey)
        
        i = 0
        let evening = [
            "evening": [
                "offset_hr": self.offsetHRLabel.text!,
                "offset_min": self.offsetMINLabel.text!,
                "off_hr": self.turnoffHRLabel.text!,
                "off_min": self.turnoffMINLabel.text!,
                "lights": [
                    "lightID": lightData[i].lightID!,
                    "onoff": "on",
                    "brightness": lightData[i].brightness!,
                    "x": lightData[i].x!,
                    "y": lightData[i].y!,
                    "type" : lightData[i].type!
                ],
            ],
            ] as [String: Any]
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: evening, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { // check for fundamental networking error
                print("error=(error)")
                
                let alertController = UIAlertController(title: "Alfred", message:
                    "Unable to save settings. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            dump(responseString)
        }
        task.resume()
    }
}
