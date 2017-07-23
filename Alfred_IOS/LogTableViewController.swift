//
//  LogTableViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 08/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import BRYXBanner

class LogTableViewController: UITableViewController {

    @IBOutlet weak var LogTableView: UITableView!
    
    var logs = [Logs]()
    var viewPage = 1 as Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getLogData(firstLoad: true) // Get log info from Alfred
    }

    //MARK: Private Methods
    func getLogData(firstLoad: Bool) {

        let AlfredBaseURL = Bundle.main.infoDictionary!["AlfredBaseURL"] as! String
        let AlfredAppKey = Bundle.main.infoDictionary!["AlfredAppKey"] as! String
        var tmpURL = "" as String
        if firstLoad {
            tmpURL = "&reverse=true"
        } else {
            tmpURL = "&page=" + String(viewPage)
        }
        let url = URL(string: AlfredBaseURL + "displaylog" + AlfredAppKey + tmpURL)
     
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
                        self.tableView.reloadData() // Refresh the table view
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogFileTableViewCell") as! LogFileTableViewCell
        let row = indexPath.row

        if logs[row].level == "info" {
            cell.infoImage.image = UIImage(named: "Information-icon.png")
        } else {
            cell.infoImage.image = UIImage(named: "error-icon.png")
        }
        cell.messagelabel.text = logs[row].message
        cell.datelabel.text = logs[row].timestamp
        
        if indexPath.row == logs.count - 1 { // if last cell check if there is more data to load
            if viewPage > 1 {
                self.viewPage -= 1
                getLogData(firstLoad: false) // Load more data
            }
        }        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }    
}
