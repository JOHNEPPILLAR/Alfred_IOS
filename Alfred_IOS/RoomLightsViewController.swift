//
//  RoomLightsViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 28/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import BRYXBanner
import MTCircularSlider

class RoomLightsViewController: UIViewController, UICollectionViewDataSource, colorPickerDelegate {
    
    var roomLightsData = [RoomLights]()
    
    @IBOutlet weak var LightCollectionViewRooms: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get room lights configuration info from Alfred
        self.getData()
        
    }
    
    //MARK: Private Methods
    func getData() {
        
        roomLightsData = [RoomLights]() // Clear data store
        
        let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        let url = URL(string: AlfredBaseURL + "lights/listlightgroups" + AlfredAppKey)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                // Update the UI
                DispatchQueue.main.async() {
                    
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to retrieve room lights. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
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
                    let jsonData = json
                    self.roomLightsData = [RoomLights(json: jsonData)]
                    
                    DispatchQueue.main.async() {
                        self.LightCollectionViewRooms.reloadData() // Refresh the colection view
                    }
                    
                } else {
                    
                    // Update the UI
                    DispatchQueue.main.async() {
                        
                        let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to retrieve room lights. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                        banner.dismissesOnTap = true
                        banner.show()
                        
                    }
                }
            }
        }).resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (roomLightsData.count) > 0 {
            return (roomLightsData[0].data!.count)
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lightCell", for: indexPath) as! LightsCollectionViewCell
        let row = indexPath.row
        
        cell.tag = Int((roomLightsData[0].data?[row].id)!)!
        
        cell.lightName.setTitle(roomLightsData[0].data?[row].name, for: .normal)
        
        // Work out light group color
        if (roomLightsData[0].data?[row].state?.anyOn)! {
            
            // Setup the light bulb colour
            var color = UIColor.white
            let xy = roomLightsData[0].data?[row].action?.xy
            if xy != nil {
                color = HueColorHelper.colorFromXY(CGPoint(x: Double((xy?[0])!), y: Double((xy?[1])!)), forModel: "LCT001")
            }
            cell.powerButton.backgroundColor = color
            
        }
        
        cell.brightnessSlider.value = Float((roomLightsData[0].data?[row].action?.bri)!)
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
        
        // Update local data store
        roomLightsData[0].data?[row].action?.bri = Int(sender.value)
        
        // Call Alfred to update the light group
        let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        
        let lightParams = "&light_number=" + "\(cell!.tag)" + "&percentage=" + String(roomLightsData[0].data![row].action!.bri!)
        let url = URL(string: AlfredBaseURL + "lights/brightenlightgroup" + AlfredAppKey + lightParams)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            if error != nil {
                
                // Update the UI
                DispatchQueue.main.async() {
                    
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to update the light group", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                }
            }
            
            guard let data = data, error == nil else { return }
            let json = JSON(data: data)
            let apiStatus = json["code"]
            let apiStatusString = apiStatus.string!
            
            if apiStatusString != "sucess" {
                
                // Update the UI
                DispatchQueue.main.async() {
                    
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to update the light group. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                    
                }
            }
        }).resume()
        
    }
    
    func powerButtonValueChange(_ sender: UITapGestureRecognizer!) {
        
        // Figure out which cell is being updated
        let point : CGPoint = sender.view!.convert(CGPoint.zero, to:LightCollectionViewRooms)
        let indexPath = LightCollectionViewRooms!.indexPathForItem(at: point)
        let cell = LightCollectionViewRooms!.cellForItem(at: indexPath!) as! LightsCollectionViewCell
        let row = indexPath?.row
        var lightsOn: String
        
        if (roomLightsData[0].data?[row!].state?.anyOn)! {
            
            roomLightsData[0].data?[row!].state?.anyOn = false
            cell.powerButton.backgroundColor = UIColor.clear
            lightsOn = "off"
            
        } else {
            
            roomLightsData[0].data?[row!].state?.anyOn = true
            lightsOn = "on"
            
            // Setup the light bulb colour
            var color = UIColor.white
            let xy = roomLightsData[0].data?[row!].action?.xy
            if xy != nil {
                color = HueColorHelper.colorFromXY(CGPoint(x: Double((xy?[0])!), y: Double((xy?[1])!)), forModel: "LCT001")
            }
            cell.powerButton.backgroundColor = color
            
            if roomLightsData[0].data?[row!].action?.bri == 0 {
                roomLightsData[0].data?[row!].action?.bri = 128
                cell.brightnessSlider.value = 128
            }
            
        }
        
        // Call Alfred to update the light group
        let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        let lightParams = "&light_number=" + "\(cell.tag)" + "&light_status=" + lightsOn + "&percentage=" + String(roomLightsData[0].data![row!].action!.bri!)
        let url = URL(string: AlfredBaseURL + "lights/lightgrouponoff" + AlfredAppKey + lightParams)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            if error != nil {
                
                // Update the UI
                DispatchQueue.main.async() {
                    
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to update the light group", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                }
            }
            
            guard let data = data, error == nil else { return }
            let json = JSON(data: data)
            let apiStatus = json["code"]
            let apiStatusString = apiStatus.string!
            
            if apiStatusString != "sucess" {
                
                // Update the UI
                DispatchQueue.main.async() {
                    
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to update the light group. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                    
                }
            }
        }).resume()
        
    }
    
    func longPowerButtonPress(_ sender: UITapGestureRecognizer!) {
        
        // Only do when finished long press
        if sender.state == .ended {
            
            // Figure out which cell is being updated
            let point : CGPoint = sender.view!.convert(CGPoint.zero, to:LightCollectionViewRooms)
            let indexPath = LightCollectionViewRooms!.indexPathForItem(at: point)
            let row = indexPath?.row
            let cell = LightCollectionViewRooms!.cellForItem(at: indexPath!) as! LightsCollectionViewCell
            cellID.sharedInstance.cell = cell
            
            // Store the color
            var color = UIColor.white
            let xy = roomLightsData[0].data?[row!].action?.xy
            if xy != nil {
                color = HueColorHelper.colorFromXY(CGPoint(x: Double((xy?[0])!), y: Double((xy?[1])!)), forModel: "LCT001")
            }
            
            // Open the color picker
            performSegue(withIdentifier: "roomsShowColor", sender: color)
            
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
        let xy = HueColorHelper.calculateXY(newColor!, forModel: "LST001")
        roomLightsData[0].data![row!].action!.xy = [Float(xy.x), Float(xy.y)]
       
        var lightsOn = "off"
        if (roomLightsData[0].data?[row!].state?.anyOn)! {
            lightsOn = "on"
        }
        
        // Call Alfred to update the light group color
        let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
        let AlfredAppKey: String = readPlist(item: "AlfredAppKey")
        var lightParams: String = "&light_number=" + "\(cell?.tag ?? 0)" + "&light_status=" + lightsOn
        lightParams = lightParams + "&percentage=" + String(roomLightsData[0].data![row!].action!.bri!)
        lightParams = lightParams + "&x=" + "\(xy.x)" + "&y=" + "\(xy.y)"
        let url = URL(string: AlfredBaseURL + "lights/lightgrouponoff" + AlfredAppKey + lightParams)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            if error != nil {
                DispatchQueue.main.async() {
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to change the light group color. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                }
            }
            
            guard let data = data, error == nil else { return }
            let json = JSON(data: data)
            let pingStatus = json["code"]
            let pingStatusString = pingStatus.string!
            
            if pingStatusString != "sucess" {
                
                DispatchQueue.main.async() {
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to change the light group color. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                }
            }
        }).resume()
        
    }
    
    @IBAction func turnOffAllLights(recognizer:UIPanGestureRecognizer) {
        let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        let url = URL(string: AlfredBaseURL + "lights/alloff" + AlfredAppKey)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            if error != nil {
                DispatchQueue.main.async() {
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to turn off all lights. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                }
            }
            
            guard let data = data, error == nil else { return }
            let json = JSON(data: data)
            let pingStatus = json["code"]
            let pingStatusString = pingStatus.string!
            
            if pingStatusString == "sucess" {
                
                // Update the UI
                DispatchQueue.main.async() {
                    
                    // Update local data & UI and turn off all light groups
                    for var i in (0..<self.roomLightsData[0].data!.count){
                        self.roomLightsData[0].data?[i].state?.anyOn = false
                        
                        let indexPath = IndexPath(row: i, section: 0)
                        let cell = self.LightCollectionViewRooms!.cellForItem(at: indexPath) as! LightsCollectionViewCell
                        cell.powerButton.backgroundColor = UIColor.clear
                        
                        i += 1
                    }
                    
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Turning off all lights.", backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show(duration: 3.0)
                    
                }
                
            } else {
                DispatchQueue.main.async() {
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to turn off all lights. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                }
            }
        }).resume()
        
    }
    
}
