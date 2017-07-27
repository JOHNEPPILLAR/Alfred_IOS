//
//  EveningTVViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 27/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

    import UIKit
    import SwiftyJSON
    import BRYXBanner
    
    class EveningTVViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
        var eveningTVData = [EveningTV]()
        
        @IBOutlet weak var LightTableViewEveningTV: UITableView!
        
        @IBOutlet weak var turnOnHRLabel: UILabel!
        @IBOutlet weak var turnOnHRStepper: UIStepper!
        @IBAction func turnOnHRStepper(_ sender: UIStepper) {
            turnOnHRLabel.text = Int(sender.value).description
            eveningTVData[0].onHr = Int(sender.value)
        }
        
        @IBOutlet weak var turnOnMINStepper: UIStepper!
        @IBOutlet weak var turnOnMINLabel: UILabel!
        @IBAction func turnOnMINStepper(_ sender: UIStepper) {
            turnOnMINLabel.text = Int(sender.value).description
            eveningTVData[0].onMin = Int(sender.value)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Add save button to navigation bar
            let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveSettingsAction(sender:)))
            navigationItem.rightBarButtonItem = saveButton
            
            // Disable UI controls untill data is loaded
            navigationItem.rightBarButtonItem?.isEnabled = false
            self.turnOnHRStepper.isEnabled = false
            self.turnOnMINStepper.isEnabled = false
            
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
                        let jsonData = json["data"]["eveningtv"]
                        self.eveningTVData = [EveningTV(json: jsonData)]
                        
                        DispatchQueue.main.async() {
                            
                            // Setup the offset and off timer settings
                            self.turnOnHRLabel.text = String(self.eveningTVData[0].onHr!)
                            self.turnOnHRStepper.value = Double(self.eveningTVData[0].onHr!)
                            
                            self.turnOnMINLabel.text = String(self.eveningTVData[0].onMin!)
                            self.turnOnMINStepper.value = Double(self.eveningTVData[0].onMin!)
                            
                            // Enable UI controls
                            self.turnOnHRStepper.isEnabled = true
                            self.turnOnMINStepper.isEnabled = true
                            self.navigationItem.rightBarButtonItem?.isEnabled = true
                            
                            // Refresh the table view
                            self.LightTableViewEveningTV.reloadData()
                            
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
            if (eveningTVData.count) > 0 {
                return (eveningTVData[0].lights?.count)!
            } else {
                return 0
            }
        }
        
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LightTableViewCellEveningTV") as! LightTableViewCell
            let row = indexPath.row
            
            // Tag colour button so can referance it later if needed
            cell.tag = indexPath.row
            
            // Populate the cell elements
            cell.LightNameLabelEveningTV.text = eveningTVData[0].lights?[row].lightName
            if eveningTVData[0].lights?[row].onoff == "on" {
                cell.onOffSwitchEveningTV.setOn(true, animated:true)
            } else {
                cell.onOffSwitchEveningTV.setOn(false, animated:true)
            }
            cell.LightBrightnessSliderEveningTV.setValue(Float((eveningTVData[0].lights?[row].brightness)!), animated: true)
            
            if eveningTVData[0].lights?[row].type == "white" {
                cell.ColorButtonEveningTV.isHidden = true
            } else {

                // Get RGB colour for button background
                var r:CGFloat = 0
                var g:CGFloat = 0
                var b:CGFloat = 0
                var a:CGFloat = 0
            
                let color = UIColor(red: CGFloat((eveningTVData[0].lights?[row].red)!)/255.0, green: CGFloat((eveningTVData[0].lights?[row].green)!)/255.0, blue: CGFloat((eveningTVData[0].lights?[row].blue)!)/255.0, alpha: 1.0)
            
                if color.getRed(&r, green: &g, blue: &b, alpha: &a){
                    cell.ColorButtonEveningTV.backgroundColor = color
                } else {
                    cell.ColorButtonEveningTV.isHidden = true
                }
            }
            
            return cell
        }
        
        func saveSettingsAction(sender: UIBarButtonItem)
        {
            
            // Disable the save button
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            //  Update table data array with UI changes
            var i = 0
            for cell in LightTableViewEveningTV.visibleCells {
                if let customCell = cell as? LightTableViewCell {
                    if customCell.onOffSwitchEveningTV.isOn {
                        eveningTVData[0].lights?[i].onoff = "on"
                    } else {
                        eveningTVData[0].lights?[i].onoff = "off"
                    }
                    eveningTVData[0].lights?[i].brightness = Int(customCell.LightBrightnessSliderEveningTV.value)
                }
                i += 1
            }
            
            // Create post request
            let AlfredBaseURL = "http://localhost:3978/"
            //let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
            let AlfredAppKey = readPlist(item: "AlfredAppKey")
            let url = URL(string: AlfredBaseURL + "settings/saveeveningtv" + AlfredAppKey)
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try! JSONSerialization.data(withJSONObject: eveningTVData[0].dictionaryRepresentation(), options: [])
            
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
