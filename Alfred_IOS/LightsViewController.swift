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
import SevenSwitch

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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        // Configure the cell
        cell.backgroundColor = UIColor.black
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    /*
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LightTableViewCellRooms") as! LightsTableViewCell
        let row = indexPath.row
        
        var color: UIColor
        if (roomLightsData[0].data?[row].state?.anyOn)! {

            // Setup the light bulb colour
            if roomLightsData[0].data?[row].action?.red != 0 &&
                roomLightsData[0].data?[row].action?.green != 0 &&
                roomLightsData[0].data?[row].action?.blue != 0 {
                
                //var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
                
                color = UIColor(red: CGFloat((roomLightsData[0].data?[row].action?.red)!)/255.0, green: CGFloat((roomLightsData[0].data?[row].action?.green)!)/255.0, blue: CGFloat((roomLightsData[0].data?[row].action?.blue)!)/255.0, alpha: 1.0)
                
            } else {
                
                color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
            }
        } else {
            
            color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            
        }
        
        cell.backgroundColor = color
        
        if color.isLight() {
            cell.lightName.textColor = UIColor.black
            cell.lightColor.setBlackBorder()
//            cell.brightnessSliderBg.layer.borderColor = UIColor.black.cgColor
            cell.lightColor.image = UIImage(named: "lightbulb_black")
        } else {
            cell.lightName.textColor = UIColor.white
            cell.lightColor.setWhiteBorder()
//            cell.brightnessSliderBg.layer.borderColor = UIColor.white.cgColor
            cell.lightColor.image = UIImage(named: "lightbulb_white")
        }
        
        cell.lightName.text = roomLightsData[0].data?[row].name
        
        // Add the custom on/off switch
        let lightSwitch = SevenSwitch()
        lightSwitch.isRounded = false
        lightSwitch.tag = Int((roomLightsData[0].data?[row].id)!)!
        cell.addSubview(lightSwitch)
        
        // Set switch state
        if (roomLightsData[0].data?[row].state?.anyOn)! {
            lightSwitch.setOn(true, animated: true)
        } else {
            lightSwitch.setOn(false, animated: true)
        }
        lightSwitch.frame = CGRect(x: 318, y: 8, width: 51, height: 31)
        lightSwitch.addTarget(self, action: #selector(LightsViewController.switchChanged(_:)), for: UIControlEvents.valueChanged)
        
        // Setup the brightness slider
        cell.lightBrightness.maximumTrackTintColor = color
        cell.lightBrightness.value = CGFloat(Float((roomLightsData[0].data?[row].action?.bri)!))
                
        return cell
        
    }
    
    
    func switchChanged(_ sender: SevenSwitch) {
        if sender.on {
            let lightID = sender.tag
            print (lightID)
            // TODO - call alfred to turn on the light group
        }
        print("Changed value to: \(sender.on)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   */
    
}
