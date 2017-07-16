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
    let logURL = "http://johneppillar.synology.me:3978/settings?app_key=631dd7b4-62bf-4dbe-93be-7eef30922bc4" as String

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
        
        //EZLoadingActivity.show("Loading...", disableUI: false) // Show loading msg
        self.getLogData() // Get sunset configuration info from Alfred
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Private Methods
    func getLogData() {
        let url = URL(string: logURL)
        
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
                                    "y": item["y"]!
                                ]
                                
                                self.lightData.append(LightData(json: jsonObject as NSDictionary))
                            }
                            
                            DispatchQueue.main.async() {
                                self.LightTableView.separatorColor = UIColor.clear
                                self.LightTableView.reloadData() // Refresh the table view
                            }
                            
                            //EZLoadingActivity.hide(true, animated: true) // Hide loading msg
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
    
        cell.LightIDLabel.text = String(describing: lightData[row].lightID)
        cell.LightNameLabel.text = lightData[row].lightName
        cell.LightIDLabel.text = String(describing: lightData[row].lightID)
        if lightData[row].onoff == "on" {
            cell.onOffSwitch.setOn(true, animated:true)
        } else {
            cell.onOffSwitch.setOn(false, animated:true)
        }
        cell.LightBrightnessSlider.setValue(Float(lightData[row].brightness!), animated: true)
        
        return cell
    }
}
