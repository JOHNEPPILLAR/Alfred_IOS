//
//  SunsetViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 14/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import BRYXBanner

class SunsetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var eveningData = [Evening]()

    @IBOutlet weak var LightTableViewEvening: UITableView!
    
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
    
    @IBAction func colourButtonPress(_ sender: RoundButton) {
        print("Color button presses")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add save button to navigation bar
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveSettingsAction(sender:)))
        navigationItem.rightBarButtonItem = saveButton

        // Disable UI controls untill data is loaded
        navigationItem.rightBarButtonItem?.isEnabled = false
        self.offsetHRStepper.isEnabled = false
        self.offsetMINStepper.isEnabled = false
        self.turnoffHRStepper.isEnabled = false
        self.turnoffMINStepper.isEnabled = false
        
        // Get sunset configuration info from Alfred
        self.getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Private Methods
    func getData() {
        
        let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        let url = URL(string: AlfredBaseURL + "settings/view" + AlfredAppKey)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            
            if error != nil {
            
                // Update the UI
                DispatchQueue.main.async() {

                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to retrieve settings. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()

                }
                
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
                        
                        // Enable UI controls
                        self.offsetHRStepper.isEnabled = true
                        self.offsetMINStepper.isEnabled = true
                        self.turnoffHRStepper.isEnabled = true
                        self.turnoffMINStepper.isEnabled = true
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                        
                        // Refresh the table view
                        self.LightTableViewEvening.reloadData()
                        
                    }
                } else {

                    // Update the UI
                    DispatchQueue.main.async() {
                    
                        let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to retrieve settings. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                        banner.dismissesOnTap = true
                        banner.show()
                        
                    }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "LightTableViewCellEvening") as! LightTableViewCell
        let row = indexPath.row

        // Tag colour button so can referance it later if needed
        cell.tag = indexPath.row

        // Populate the cell elements
        cell.LightNameLabelEvening.text = eveningData[0].lights?[row].lightName
        if eveningData[0].lights?[row].onoff == "on" {
            cell.onOffSwitchEvening.setOn(true, animated:true)
        } else {
            cell.onOffSwitchEvening.setOn(false, animated:true)
        }
        cell.LightBrightnessSliderEvening.setValue(Float((eveningData[0].lights?[row].brightness)!), animated: true)
        
        // Get RGB colour for button background
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        let color = UIColor(red: CGFloat((eveningData[0].lights?[row].red)!)/255.0, green: CGFloat((eveningData[0].lights?[row].green)!)/255.0, blue: CGFloat((eveningData[0].lights?[row].blue)!)/255.0, alpha: 1.0)

        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
            cell.ColorButtonEvening.backgroundColor = color
        } else {
            cell.ColorButtonEvening.isHidden = true
        }
        
        return cell
    }
    
    func saveSettingsAction(sender: UIBarButtonItem)
    {
        
        // Disable the save button
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        //  Update table data array with UI changes
        var i = 0
        for cell in LightTableViewEvening.visibleCells {
            if let customCell = cell as? LightTableViewCell {
                if customCell.onOffSwitchEvening.isOn {
                    eveningData[0].lights?[i].onoff = "on"
                } else {
                    eveningData[0].lights?[i].onoff = "off"
                }
                eveningData[0].lights?[i].brightness = Int(customCell.LightBrightnessSliderEvening.value)
            }
            i += 1
        }
        
        // Create post request
        let AlfredBaseURL = "http://localhost:3978/"
        //let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        let url = URL(string: AlfredBaseURL + "settings/saveevening" + AlfredAppKey)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: eveningData[0].dictionaryRepresentation(), options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Update the UI
            DispatchQueue.main.async() {

                guard let data = data, error == nil else { // Check for fundamental networking error
                    print("save data error: " + error.debugDescription)
                
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to save data. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                
                    // Re enable the save button
                    self.navigationItem.rightBarButtonItem?.isEnabled = true

                    return
                }

                let json = JSON(data: data)
                let apiStatus = json["code"]
                let apiStatusString = apiStatus.string!
            
                if apiStatusString == "sucess" {
                
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Saved.", backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show(duration: 3.0)

                } else {

                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to save data. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()

                }

                // Re enable the save button
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
        task.resume()
    }
}
