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
import MTCircularSlider
import IMGLYColorPicker

class SunsetViewController: UIViewController, UICollectionViewDataSource, colorPickerDelegate {
    
    var eveningData = [Evening]()

    @IBOutlet weak var LightCollectionView: UICollectionView!

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
        
        if (eveningData.count) > 0 {
            return (eveningData[0].lights?.count)!
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lightCell", for: indexPath) as! LightsCollectionViewCell
        let row = indexPath.row
        
        cell.tag = (eveningData[0].lights?[row].lightID)!
        
        cell.lightName.setTitle(eveningData[0].lights?[row].lightName, for: .normal)
        
        // Work out light group color
        var color: UIColor
        if (eveningData[0].lights?[row].onoff == "on") {
            
            // Setup the light bulb colour
            if eveningData[0].lights?[row].red != 0 &&
                eveningData[0].lights?[row].green != 0 &&
                eveningData[0].lights?[row].blue != 0 {
                
                color = UIColor(red: CGFloat((eveningData[0].lights?[row].red)!)/255.0, green: CGFloat((eveningData[0].lights?[row].green)!)/255.0, blue: CGFloat((eveningData[0].lights?[row].blue)!)/255.0, alpha: 1.0)
                
            } else {
                
                color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }
            
            cell.powerButton.backgroundColor = color
            cell.brightnessSlider.value = Float((eveningData[0].lights?[row].brightness)!)
            
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
        eveningData[0].lights?[row].brightness = Int(sender.value)
        if sender.value == 0 {
            
            eveningData[0].lights?[row].onoff = "off"
            cell?.powerButton.backgroundColor = UIColor.clear
            
        } else {
            
            eveningData[0].lights?[row].onoff = "on"
            
            // Setup the light bulb colour
            if (eveningData[0].lights?[row].red)! != 0 &&
                (eveningData[0].lights?[row].green)! != 0 &&
                (eveningData[0].lights?[row].blue)! != 0 {
                
                color = UIColor(red: CGFloat((eveningData[0].lights?[row].red)!)/255.0, green: CGFloat((eveningData[0].lights?[row].green)!)/255.0, blue: CGFloat((eveningData[0].lights?[row].blue)!)/255.0, alpha: 1.0)
                
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
        
        
        if (eveningData[0].lights?[row!].onoff == "on") {
            
            eveningData[0].lights?[row!].onoff = "off"
            cell.powerButton.backgroundColor = UIColor.clear
            
        } else {
            
            eveningData[0].lights?[row!].onoff = "on"
            
            // Setup the light bulb colour
            if eveningData[0].lights?[row!].red != 0 &&
                eveningData[0].lights?[row!].green != 0 &&
                eveningData[0].lights?[row!].blue != 0 {
                
                color = UIColor(red: CGFloat((eveningData[0].lights?[row!].red)!)/255.0, green: CGFloat((eveningData[0].lights?[row!].green)!)/255.0, blue: CGFloat((eveningData[0].lights?[row!].blue)!)/255.0, alpha: 1.0)
                
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
            if eveningData[0].lights?[row!].red != 0 &&
                eveningData[0].lights?[row!].green != 0 &&
                eveningData[0].lights?[row!].blue != 0 {
                
                color = UIColor(red: CGFloat((eveningData[0].lights?[row!].red)!)/255.0, green: CGFloat((eveningData[0].lights?[row!].green)!)/255.0, blue: CGFloat((eveningData[0].lights?[row!].blue)!)/255.0, alpha: 1.0)
                
            } else {
                
                color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }
            
            // Open the color picker
            performSegue(withIdentifier: "sunsetShowColor", sender: color)
            
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
        eveningData[0].lights?[row!].red = Int((rgb?.red)!)
        eveningData[0].lights?[row!].green = Int((rgb?.green)!)
        eveningData[0].lights?[row!].blue = Int((rgb?.blue)!)
        
    }
    
    func saveSettingsAction(sender: UIBarButtonItem)
    {
        
        // Disable the save button
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // Create post request
        //let AlfredBaseURL = "http://localhost:3978/"
        let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
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
