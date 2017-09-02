//
//  TVViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 30/08/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import BRYXBanner

class TVViewController: UIViewController {

    @IBAction func TV_off(_ sender: Any) {
    
        let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        let url = URL(string: AlfredBaseURL + "tv/turnoff" + AlfredAppKey)
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
       
            // Update the UI
            if error != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Network/API connection error. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                })
            }
            
            guard let data = data, error == nil else { return }
            let json = JSON(data: data)
            let apiStatus = json["code"]
            let apiStatusString = apiStatus.string!
            
            if apiStatusString == "sucess" {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {

                    let banner = Banner(title: "Alfred API Notification", subtitle: "Turned off TV.", backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show(duration: 3.0)
                
                })
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to turn off TV. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                })
            }
        }).resume()
    }
    
    @IBAction func TV_on(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            let banner = Banner(title: "Alfred API Notification", subtitle: "TO DO.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
            banner.dismissesOnTap = true
            banner.show(duration: 3.0)
        })
        
    }
    
    @IBAction func Fire_tv(_ sender: Any) {

        let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        let url = URL(string: AlfredBaseURL + "tv/watchfiretv" + AlfredAppKey)

        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            
            // Update the UI
            if error != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Network/API connection error. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                })
            }
            
            guard let data = data, error == nil else { return }
            let json = JSON(data: data)
            let apiStatus = json["code"]
            let apiStatusString = apiStatus.string!
            
            if apiStatusString == "sucess" {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Turned on Fire TV.", backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show(duration: 3.0)
                    
                })
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to turn on Fire TV. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                })
            }
        }).resume()
    
    }
    
    @IBAction func Virgin_tv(_ sender: Any) {

        let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        let url = URL(string: AlfredBaseURL + "tv/watchvirgintv" + AlfredAppKey)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            
            // Update the UI
            if error != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Network/API connection error. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                })
            }
            
            guard let data = data, error == nil else { return }
            let json = JSON(data: data)
            let apiStatus = json["code"]
            let apiStatusString = apiStatus.string!
            
            if apiStatusString == "sucess" {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Turned on Virgin TV.", backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show(duration: 3.0)
                    
                })
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to turn on Virgin TV. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                })
            }
        }).resume()

    }
    
    @IBAction func Apple_tv(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            let banner = Banner(title: "Alfred API Notification", subtitle: "TO DO.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
            banner.dismissesOnTap = true
            banner.show(duration: 3.0)
        })
        
    }
    
    @IBAction func Playstation(_ sender: Any) {
    
        let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        let url = URL(string: AlfredBaseURL + "tv/playps4" + AlfredAppKey)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            
            // Update the UI
            if error != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Network/API connection error. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                })
            }
            
            guard let data = data, error == nil else { return }
            let json = JSON(data: data)
            let apiStatus = json["code"]
            let apiStatusString = apiStatus.string!
            
            if apiStatusString == "sucess" {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Turned on Play Station.", backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show(duration: 3.0)
                    
                })
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to turn on Play Station. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                })
            }
        }).resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
