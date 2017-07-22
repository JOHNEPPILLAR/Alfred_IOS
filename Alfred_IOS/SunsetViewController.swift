//
//  SunsetViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 14/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

class SunsetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var eveningData = [Evening]()
    
    @IBOutlet weak var LightTableView: UITableView!
    
    @IBOutlet weak var offsetHRLabel: UILabel!
    @IBOutlet weak var offsetHRStepper: UIStepper!
    @IBAction func offsetHRStepper(_ sender: UIStepper) {
        offsetHRLabel.text = Int(sender.value).description
        eveningData[0].offsetHr = Int(sender.value)
    }
    
    @IBOutlet weak var offsetMINLabel: UILabel!
    @IBOutlet weak var offsetMINStepper: UIStepper!
    @IBAction func offsetMINStepper(_ sender: UIStepper) {
        offsetMINLabel.text = Int(sender.value).description
        eveningData[0].offsetMin = Int(sender.value)
    }
    
    @IBOutlet weak var turnoffHRLabel: UILabel!
    @IBOutlet weak var turnoffHRStepper: UIStepper!
    @IBAction func turnoffHRStepper(_ sender: UIStepper) {
        turnoffHRLabel.text = Int(sender.value).description
        eveningData[0].offHr = Int(sender.value)
    }
    
    @IBOutlet weak var turnoffMINLabel: UILabel!
    @IBOutlet weak var turnoffMINStepper: UIStepper!
    @IBAction func turnoffMINStepper(_ sender: UIStepper) {
        turnoffMINLabel.text = Int(sender.value).description
        eveningData[0].offMin = Int(sender.value)
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
                let json = JSON(data: data)
                let apiStatus = json["code"]
                let apiStatusString = apiStatus.string!
                    
                if apiStatusString == "sucess" {

                    // Save json to custom classes
                    let jsonData = json["data"]["evening"]
                    self.eveningData = [Evening(json: jsonData)]
                    
                    DispatchQueue.main.async() {
                            
                        // Setup the offset and off timer settings
                        self.offsetHRLabel.text = String(self.eveningData[0].offsetHr!)
                        self.offsetHRStepper.value = Double(self.eveningData[0].offsetHr!)
 
                        self.offsetMINLabel.text = String(self.eveningData[0].offsetMin!)
                        self.offsetMINStepper.value = Double(self.eveningData[0].offsetMin!)
                            
                        self.turnoffHRLabel.text = String(self.eveningData[0].offHr!)
                        self.turnoffHRStepper.value = Double(self.eveningData[0].offHr!)
                            
                        self.turnoffMINLabel.text = String(self.eveningData[0].offMin!)
                        self.turnoffMINStepper.value = Double(self.eveningData[0].offMin!)
                            
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
            }
        }).resume()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (eveningData.count) > 0 {
            return (eveningData[0].lights?.count)!
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LightTableViewCell") as! LightTableViewCell
        let row = indexPath.row
        
        cell.LightNameLabel.text = eveningData[0].lights?[row].lightName
        if eveningData[0].lights?[row].onoff == "on" {
            cell.onOffSwitch.setOn(true, animated:true)
        } else {
            cell.onOffSwitch.setOn(false, animated:true)
        }
        cell.LightBrightnessSlider.setValue(Float((eveningData[0].lights?[row].brightness)!), animated: true)
        cell.xLabel.text = String(describing: eveningData[0].lights?[row].x)
        cell.yLabel.text = String(describing: eveningData[0].lights?[row].y)
        
        return cell
    }
    

    func saveSettingsAction(sender: UIBarButtonItem)
    {
        
        // Disable the save button
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        EZLoadingActivity.show("Saving data...", disableUI: false) // Show loading msg
        
        //  Update table data array with UI changes
        var i = 0
        for cell in LightTableView.visibleCells {
            if let customCell = cell as? LightTableViewCell {
                if customCell.onOffSwitch.isOn {
                    eveningData[0].lights?[i].onoff = "on"
                } else {
                    eveningData[0].lights?[i].onoff = "off"
                }
                eveningData[0].lights?[i].brightness = Int(customCell.LightBrightnessSlider.value)
                eveningData[0].lights?[i].x = Int(customCell.xLabel.text!)
                eveningData[0].lights?[i].y = Int(customCell.yLabel.text!)
            }
            i += 1
        }
        
        // Create post request
        let AlfredBaseURL = "http://localhost:3978/"
        let AlfredAppKey = Bundle.main.infoDictionary!["AlfredAppKey"] as! String
        let url = URL(string: AlfredBaseURL + "savesettings" + AlfredAppKey)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: eveningData[0].dictionaryRepresentation(), options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Update the UI
            DispatchQueue.main.async() {

                EZLoadingActivity.hide(true, animated: true) // Hide loading msg
                
                guard let data = data, error == nil else { // check for fundamental networking error
                    print("save data error: " + error.debugDescription)
                
                    let alertController = UIAlertController(title: "Alfred", message:
                        "Unable to save settings. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alertController, animated: true, completion: nil)
                
                    // Re enable the save button
                    self.navigationItem.rightBarButtonItem?.isEnabled = true

                    return
                }
                let json = JSON(data: data)
                let apiStatus = json["code"]
                let apiStatusString = apiStatus.string!
            
                if apiStatusString == "sucess" {
                    let alertController = UIAlertController(title: "Alfred", message:
                        "Settings saved.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Alfred", message:
                        "Unable to save settings. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alertController, animated: true, completion: nil)
                }
            
                // Re enable the save button
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
        task.resume()
    }
}
