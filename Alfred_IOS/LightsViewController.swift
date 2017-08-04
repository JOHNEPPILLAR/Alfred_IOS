//
//  LightsViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 28/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import BRYXBanner
import MTCircularSlider

class LightsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var roomLightsData = [RoomLights]()
    
    @IBOutlet weak var LightCollectionViewRooms: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a power off lights button to the nav bar
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "power"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(self.turnOffAllLights), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        // Get room lights configuration info from Alfred
        self.getData()
        
    }
    
    func turnOffAllLights()
    {
        let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        let url = URL(string: AlfredBaseURL + "lights/alloff" + AlfredAppKey)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            if error != nil {
                DispatchQueue.main.async() {
                    print ("Lights - Unable to turn off all ligths")
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
                DispatchQueue.main.async() {
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Turning off all lights.", backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show(duration: 3.0)
                }
            } else {
                DispatchQueue.main.async() {
                    print ("Lights - Unable to turn off all ligths")
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to turn off all lights. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                }
            }
        }).resume()
    }
    
    //MARK: Private Methods
    func getData() {
        
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
                        
                        self.LightCollectionViewRooms.reloadData() // Refresh the table view
                        
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
        var color: UIColor
        if (roomLightsData[0].data?[row].state?.anyOn)! {
            
            // Setup the light bulb colour
            if roomLightsData[0].data?[row].action?.red != 0 &&
                roomLightsData[0].data?[row].action?.green != 0 &&
                roomLightsData[0].data?[row].action?.blue != 0 {
                
                color = UIColor(red: CGFloat((roomLightsData[0].data?[row].action?.red)!)/255.0, green: CGFloat((roomLightsData[0].data?[row].action?.green)!)/255.0, blue: CGFloat((roomLightsData[0].data?[row].action?.blue)!)/255.0, alpha: 1.0)
                
            } else {
                
                color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }

            cell.powerButton.backgroundColor = color

            
            cell.brightnessSlider.value = Float((roomLightsData[0].data?[row].action?.bri)!)

        } 
        
        cell.brightnessSlider.tag = row
        cell.brightnessSlider?.addTarget(self, action: #selector(brightnessValueChange(_:)), for: .valueChanged)
        
        // Configure the power button
        cell.powerButton.tag = row
        cell.powerButton.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(powerButtonValueChange(_:)))
        cell.powerButton.addGestureRecognizer(tapRecognizer)
        
        return cell
    }
    
    
    func brightnessValueChange(_ sender: MTCircularSlider!) {
        
        // Figure out which cell is being updated
        let point : CGPoint = sender.convert(CGPoint.zero, to:LightCollectionViewRooms)
        let indexPath = LightCollectionViewRooms!.indexPathForItem(at: point)
        let cell = LightCollectionViewRooms!.cellForItem(at: indexPath!) as! LightsCollectionViewCell
        let row = indexPath?.row
        
        // Update local data store
        roomLightsData[0].data?[row!].action?.bri = Int(sender.value)
        if sender.value == 0 {
            roomLightsData[0].data?[row!].state?.anyOn = false
            cell.powerButton.backgroundColor = UIColor.clear
        } else {
            roomLightsData[0].data?[row!].state?.anyOn = true
            // Setup the light bulb colour
            if roomLightsData[0].data?[row!].action?.red != 0 &&
                roomLightsData[0].data?[row!].action?.green != 0 &&
                roomLightsData[0].data?[row!].action?.blue != 0 {
                
                let color = UIColor(red: CGFloat((roomLightsData[0].data?[row!].action?.red)!)/255.0, green: CGFloat((roomLightsData[0].data?[row!].action?.green)!)/255.0, blue: CGFloat((roomLightsData[0].data?[row!].action?.blue)!)/255.0, alpha: 1.0)
                
                cell.powerButton.backgroundColor = color
        
            }
        }

        // Call Alfred to update the light group
        // TO DO
            
    }
    
    func powerButtonValueChange(_ sender: UITapGestureRecognizer!) {
        
        // Figure out which cell is being updated
        let point : CGPoint = sender.view!.convert(CGPoint.zero, to:LightCollectionViewRooms)
        let indexPath = LightCollectionViewRooms!.indexPathForItem(at: point)
        let cell = LightCollectionViewRooms!.cellForItem(at: indexPath!) as! LightsCollectionViewCell
        let row = indexPath?.row
        
        if (roomLightsData[0].data?[row!].state?.anyOn)! {
            roomLightsData[0].data?[row!].state?.anyOn = false
            cell.powerButton.backgroundColor = UIColor.clear
        } else {
            roomLightsData[0].data?[row!].state?.anyOn = true

            // Setup the light bulb colour
            if roomLightsData[0].data?[row!].action?.red != 0 &&
                roomLightsData[0].data?[row!].action?.green != 0 &&
                roomLightsData[0].data?[row!].action?.blue != 0 {
                
                let color = UIColor(red: CGFloat((roomLightsData[0].data?[row!].action?.red)!)/255.0, green: CGFloat((roomLightsData[0].data?[row!].action?.green)!)/255.0, blue: CGFloat((roomLightsData[0].data?[row!].action?.blue)!)/255.0, alpha: 1.0)
                
                cell.powerButton.backgroundColor = color
                
            }
            
        }
    
    }
    
}
