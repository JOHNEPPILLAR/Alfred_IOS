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

class LightsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var roomLightsData = [RoomLights]()

    @IBOutlet weak var LightTableViewRooms: UITableView!
    
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
                        
                        self.LightTableViewRooms.reloadData() // Refresh the table view
                        
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
 
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (roomLightsData.count) > 0 {
            return (roomLightsData[0].data!.count)
        } else {
            return 0
        }
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LightTableViewCellRooms") as! LightsTableViewCell
        let row = indexPath.row
 
        // Tag colour button so can referance it later if needed
        cell.tag = indexPath.row
        
        // Populate the cell elements
        cell.lightName.text = roomLightsData[0].data?[row].name
        if (roomLightsData[0].data?[row].state?.anyOn)! {
            cell.lightSwitch.setOn(true, animated:true)
        } else {
            cell.lightSwitch.setOn(false, animated:true)
        }
        
        
        
        
        return cell
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
