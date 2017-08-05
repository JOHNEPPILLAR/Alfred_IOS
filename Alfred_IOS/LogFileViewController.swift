//
//  LogFileViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 05/08/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import BRYXBanner

class LogFileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var LogFileTableView: UITableView!
    
    var logs = [Logs]()
    var viewPage = 1 as Int
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LogFileTableView.backgroundView = UIImageView(image: UIImage(named: "background.jpg"))
        
        self.getData() // Get log info from Alfred
        
    }

    //MARK: Private Methods
    func getData() {
        
        let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        let url = URL(string: AlfredBaseURL + "displaylog" + AlfredAppKey + "&page=" + String(viewPage))
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            if error != nil {
                
                let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to retrieve logfile data. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                banner.dismissesOnTap = true
                banner.show()
                
            } else {
                
                let data = data
                let json = JSON(data: data!)
                let apiStatus = json["code"]
                let apiStatusString = apiStatus.string!
                
                if apiStatusString == "sucess" {
                    
                    let logData = json["data"]
                    let currentpagejson = logData["currentpage"]
                    self.viewPage = currentpagejson.int!
                    
                    for item in logData["logs"] {
                        self.logs.append(Logs(json: item.1))
                    }
                    
                    // Update the UI
                    DispatchQueue.main.async() {
                        self.LogFileTableView.reloadData() // Refresh the table view
                    }
                    
                } else {
                    
                    // Update the UI
                    DispatchQueue.main.async() {
                        let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to retrieve logfile data. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                        banner.dismissesOnTap = true
                        banner.show()
                    }
                    
                }
            }
        }).resume()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (logs.count) > 0 {
            return (logs.count)
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogFileTableViewCell") as! LogFileTableViewCell
        let row = indexPath.row
        
        cell.backgroundColor = .clear
        
        if logs[row].level == "info" {
            cell.infoImage.image = UIImage(named: "Information-icon.png")
        } else {
            cell.infoImage.image = UIImage(named: "error-icon.png")
        }
        cell.messagelabel.text = logs[row].message
        cell.datelabel.text = logs[row].timestamp
        
        if indexPath.row == logs.count - 1 { // if last cell check if there is more data to load
            self.viewPage += 1
            getData() // Load more data
        }
    
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
