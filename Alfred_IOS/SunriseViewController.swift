//
//  SunriseViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 26/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import BRYXBanner
import MTCircularSlider

class SunriseViewController: UIViewController, UICollectionViewDataSource {

    var morningData = [Morning]()
    
    @IBOutlet weak var LightCollectionView: UICollectionView!
    
    @IBOutlet weak var TableView: UITableView!
    @IBAction func turnOnHRStepper(_ sender: UIStepper) {
        turnOnHRLabel.text = Int(sender.value).description
        morningData[0].onHr = Int(sender.value)
    }
    @IBOutlet weak var turnOnHRStepper: UIStepper!
    @IBOutlet weak var turnOnHRLabel: UILabel!
    
    @IBAction func turnOnMINStepper(_ sender: UIStepper) {
        turnOnMINLabel.text = Int(sender.value).description
        morningData[0].onMin = Int(sender.value)
    }
    @IBOutlet weak var turnOnMINStepper: UIStepper!
    @IBOutlet weak var turnOnMINLabel: UILabel!
    
    @IBAction func turnOffHRStepper(_ sender: UIStepper) {
        turnOffHRLabel.text = Int(sender.value).description
        morningData[0].offHr = Int(sender.value)
    }
    @IBOutlet weak var turnOffHRStepper: UIStepper!
    @IBOutlet weak var turnOffHRLabel: UILabel!
    
    @IBAction func turnOffMINStepper(_ sender: UIStepper) {
        turnOffMINLabel.text = Int(sender.value).description
        morningData[0].offMin = Int(sender.value)
    }
    @IBOutlet weak var turnOffMINStepper: UIStepper!
    @IBOutlet weak var turnOffMINLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add save button to navigation bar
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveSettingsAction(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        
        // Disable UI controls untill data is loaded
        navigationItem.rightBarButtonItem?.isEnabled = false
        self.turnOnHRStepper.isEnabled = false
        self.turnOnHRStepper.isEnabled = false
        self.turnOnHRStepper.isEnabled = false
        self.turnOffHRStepper.isEnabled = false
        
        // Get sunrise configuration info from Alfred
        self.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    let jsonData = json["data"]["morning"]
                    self.morningData = [Morning(json: jsonData)]
                    
                    DispatchQueue.main.async() {
                        
                        // Setup the offset and off timer settings
                        self.turnOnHRLabel.text = String(self.morningData[0].onHr!)
                        self.turnOnHRStepper.value = Double(self.morningData[0].onHr!)
                        self.turnOnMINLabel.text = String(self.morningData[0].onMin!)
                        self.turnOnMINStepper.value = Double(self.morningData[0].onMin!)
                        
                        self.turnOffHRLabel.text = String(self.morningData[0].offHr!)
                        self.turnOffHRStepper.value = Double(self.morningData[0].offHr!)
                        
                        self.turnOffMINLabel.text = String(self.morningData[0].offMin!)
                        self.turnOffMINStepper.value = Double(self.morningData[0].offMin!)
                        
                        // Enable UI controls
                        self.turnOnHRStepper.isEnabled = true
                        self.turnOnMINStepper.isEnabled = true
                        self.turnOffHRStepper.isEnabled = true
                        self.turnOffMINStepper.isEnabled = true
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

        if (morningData.count) > 0 {
            return (morningData[0].lights?.count)!
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lightCell", for: indexPath) as! LightsCollectionViewCell
        let row = indexPath.row
        
        cell.tag = (morningData[0].lights?[row].lightID)!
        
        cell.lightName.setTitle(morningData[0].lights?[row].lightName, for: .normal)

        // Work out light group color
        var color: UIColor
        if (morningData[0].lights?[row].onoff == "on") {
            
            // Setup the light bulb colour
            if morningData[0].lights?[row].red != 0 &&
                morningData[0].lights?[row].green != 0 &&
                morningData[0].lights?[row].blue != 0 {
                
                color = UIColor(red: CGFloat((morningData[0].lights?[row].red)!)/255.0, green: CGFloat((morningData[0].lights?[row].green)!)/255.0, blue: CGFloat((morningData[0].lights?[row].blue)!)/255.0, alpha: 1.0)
                
            } else {
                
                color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }
            
            cell.powerButton.backgroundColor = color
            cell.brightnessSlider.value = Float((morningData[0].lights?[row].brightness)!)
            
        }
        
        cell.brightnessSlider.tag = row
        cell.brightnessSlider?.addTarget(self, action: #selector(brightnessValueChange(_:)), for: .touchUpInside)
        
        // Configure the power button
        cell.powerButton.tag = row
        cell.powerButton.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(powerButtonPress(_:)))
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
        morningData[0].lights?[row].brightness = Int(sender.value)
        if sender.value == 0 {

            morningData[0].lights?[row].onoff = "off"
            cell?.powerButton.backgroundColor = UIColor.clear
            
        } else {
            
            morningData[0].lights?[row].onoff = "on"
            
            // Setup the light bulb colour
            if (morningData[0].lights?[row].red)! != 0 &&
                (morningData[0].lights?[row].green)! != 0 &&
                (morningData[0].lights?[row].blue)! != 0 {
                
                color = UIColor(red: CGFloat((morningData[0].lights?[row].red)!)/255.0, green: CGFloat((morningData[0].lights?[row].green)!)/255.0, blue: CGFloat((morningData[0].lights?[row].blue)!)/255.0, alpha: 1.0)
                
            } else {
                
                color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }
            cell?.powerButton.backgroundColor = color
            
        }
        
    }
    
    func powerButtonPress(_ sender: UITapGestureRecognizer!) {
        
        // Figure out which cell is being updated
        let point : CGPoint = sender.view!.convert(CGPoint.zero, to:LightCollectionView)
        let indexPath = LightCollectionView!.indexPathForItem(at: point)
        let cell = LightCollectionView!.cellForItem(at: indexPath!) as! LightsCollectionViewCell
        let row = indexPath?.row
        var color: UIColor

        
        if (morningData[0].lights?[row!].onoff == "on") {
            
            morningData[0].lights?[row!].onoff = "off"
            cell.powerButton.backgroundColor = UIColor.clear
            
        } else {
            
            morningData[0].lights?[row!].onoff = "on"
            
            // Setup the light bulb colour
            if morningData[0].lights?[row!].red != 0 &&
                morningData[0].lights?[row!].green != 0 &&
                morningData[0].lights?[row!].blue != 0 {
                
                color = UIColor(red: CGFloat((morningData[0].lights?[row!].red)!)/255.0, green: CGFloat((morningData[0].lights?[row!].green)!)/255.0, blue: CGFloat((morningData[0].lights?[row!].blue)!)/255.0, alpha: 1.0)
                
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
            let cell = LightCollectionView!.cellForItem(at: indexPath!) as! LightsCollectionViewCell
            
            cellID.sharedInstance.cell = cell
            performSegue(withIdentifier: "sunriseShowColor", sender: cell)
            
        }
    }
    
    func saveSettingsAction(sender: UIBarButtonItem) {
        
        // Disable the save button
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // Create post request
        //let AlfredBaseURL = "http://localhost:3978/"
        let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        let url = URL(string: AlfredBaseURL + "settings/savemorning" + AlfredAppKey)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: morningData[0].dictionaryRepresentation(), options: [])
        
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
