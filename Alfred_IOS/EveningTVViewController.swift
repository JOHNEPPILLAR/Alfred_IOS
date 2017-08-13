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
    import MTCircularSlider
    
    class EveningTVViewController: UIViewController, UICollectionViewDataSource, colorPickerDelegate {
        
        var eveningTVData = [EveningTV]()
        
        @IBOutlet weak var LightCollectionView: UICollectionView!
        
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
            
            // Get evening TV lights configuration info from Alfred
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
                            self.LightCollectionView.reloadData()
                            
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
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            if (eveningTVData.count) > 0 {
                return (eveningTVData[0].lights?.count)!
            } else {
                return 0
            }
            
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lightCell", for: indexPath) as! LightsCollectionViewCell
            let row = indexPath.row
            
            cell.tag = (eveningTVData[0].lights?[row].lightID)!
            
            cell.lightName.setTitle(eveningTVData[0].lights?[row].lightName, for: .normal)
            
            // Work out light group color
            var color: UIColor
            if (eveningTVData[0].lights?[row].onoff == "on") {
                
                // Setup the light bulb colour
                if eveningTVData[0].lights?[row].red != 0 &&
                    eveningTVData[0].lights?[row].green != 0 &&
                    eveningTVData[0].lights?[row].blue != 0 {
                    
                    color = UIColor(red: CGFloat((eveningTVData[0].lights?[row].red)!)/255.0, green: CGFloat((eveningTVData[0].lights?[row].green)!)/255.0, blue: CGFloat((eveningTVData[0].lights?[row].blue)!)/255.0, alpha: 1.0)
                    
                } else {
                    
                    color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    
                }
                
                cell.powerButton.backgroundColor = color
                cell.brightnessSlider.value = Float((eveningTVData[0].lights?[row].brightness)!)
                
            }
            
            cell.brightnessSlider.tag = row
            cell.brightnessSlider?.addTarget(self, action: #selector(brightnessValueChange(_:)), for: .touchUpInside)
            
            // Configure the power button
            cell.powerButton.tag = row
            cell.powerButton.isUserInteractionEnabled = true
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(powerButtonValueChange(_:)))
            cell.powerButton.addGestureRecognizer(tapRecognizer)
            let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPowerButtonPress(_:)))
            cell.powerButton.addGestureRecognizer(longTapRecognizer)

            return cell
            
        }
        
        func brightnessValueChange(_ sender: MTCircularSlider!) {
            
            // Figure out which cell is being updated
            let cell = sender.superview?.superview as? LightsCollectionViewCell
            let row = sender.tag
            var color: UIColor
            
            // Update local data store
            eveningTVData[0].lights?[row].brightness = Int(sender.value)
            if sender.value == 0 {
                
                eveningTVData[0].lights?[row].onoff = "off"
                cell?.powerButton.backgroundColor = UIColor.clear
                
            } else {
                
                eveningTVData[0].lights?[row].onoff = "on"
                
                // Setup the light bulb colour
                if (eveningTVData[0].lights?[row].red)! != 0 &&
                    (eveningTVData[0].lights?[row].green)! != 0 &&
                    (eveningTVData[0].lights?[row].blue)! != 0 {
                    
                    color = UIColor(red: CGFloat((eveningTVData[0].lights?[row].red)!)/255.0, green: CGFloat((eveningTVData[0].lights?[row].green)!)/255.0, blue: CGFloat((eveningTVData[0].lights?[row].blue)!)/255.0, alpha: 1.0)
                    
                } else {
                    
                    color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    
                }
                cell?.powerButton.backgroundColor = color
                
            }
            
        }
        
        func powerButtonValueChange(_ sender: UITapGestureRecognizer!) {
            
            // Figure out which cell is being updated
            let point : CGPoint = sender.view!.convert(CGPoint.zero, to:LightCollectionView)
            let indexPath = LightCollectionView!.indexPathForItem(at: point)
            let cell = LightCollectionView!.cellForItem(at: indexPath!) as! LightsCollectionViewCell
            let row = indexPath?.row
            var color: UIColor
            
            
            if (eveningTVData[0].lights?[row!].onoff == "on") {
                
                eveningTVData[0].lights?[row!].onoff = "off"
                cell.powerButton.backgroundColor = UIColor.clear
                
            } else {
                
                eveningTVData[0].lights?[row!].onoff = "on"
                
                // Setup the light bulb colour
                if eveningTVData[0].lights?[row!].red != 0 &&
                    eveningTVData[0].lights?[row!].green != 0 &&
                    eveningTVData[0].lights?[row!].blue != 0 {
                    
                    color = UIColor(red: CGFloat((eveningTVData[0].lights?[row!].red)!)/255.0, green: CGFloat((eveningTVData[0].lights?[row!].green)!)/255.0, blue: CGFloat((eveningTVData[0].lights?[row!].blue)!)/255.0, alpha: 1.0)
                    
                } else {
                    
                    color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    
                }
                cell.powerButton.backgroundColor = color
                
            }
        }
  
        func longPowerButtonPress(_ sender: UITapGestureRecognizer!) {
            
            // Only do when finished long press
            if sender.state == .ended {
                
                // Figure out which cell is being updated
                let point : CGPoint = sender.view!.convert(CGPoint.zero, to:LightCollectionView)
                let indexPath = LightCollectionView!.indexPathForItem(at: point)
                let row = indexPath?.row
                let cell = LightCollectionView!.cellForItem(at: indexPath!) as! LightsCollectionViewCell
                cellID.sharedInstance.cell = cell
                
                // Store the color
                var color: UIColor
                if eveningTVData[0].lights?[row!].red != 0 &&
                    eveningTVData[0].lights?[row!].green != 0 &&
                    eveningTVData[0].lights?[row!].blue != 0 {
                    
                    color = UIColor(red: CGFloat((eveningTVData[0].lights?[row!].red)!)/255.0, green: CGFloat((eveningTVData[0].lights?[row!].green)!)/255.0, blue: CGFloat((eveningTVData[0].lights?[row!].blue)!)/255.0, alpha: 1.0)
                    
                } else {
                    
                    color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    
                }
                
                // Open the color picker
                performSegue(withIdentifier: "eveningTVShowColor", sender: color)
                
            }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            let secondViewController = segue.destination as! ColorViewController
            secondViewController.delegate = self
            secondViewController.colorID = sender as? UIColor
            
        }
        
        func backFromColorPicker(_ newColor: UIColor?) {
            
            // Update the button background
            let cell = cellID.sharedInstance.cell
            cell?.powerButton.backgroundColor = newColor
            
            // Update the local data store
            let row = cell?.powerButton.tag
            let rgb = newColor?.rgb()
            eveningTVData[0].lights?[row!].red = Int((rgb?.red)!)
            eveningTVData[0].lights?[row!].green = Int((rgb?.green)!)
            eveningTVData[0].lights?[row!].blue = Int((rgb?.blue)!)
            
        }
        
        
        func saveSettingsAction(sender: UIBarButtonItem)
        {
            
            // Disable the save button
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            // Create post request
            let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
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
