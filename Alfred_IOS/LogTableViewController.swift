//
//  LogTableViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 08/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit

class LogTableViewController: UITableViewController {

    @IBOutlet weak var LogTableView: UITableView!
    
    var logFileData = [LogFileData]()
    var viewPage = 1 as Int
    let logURL = "http://johneppillar.synology.me:3978/displaylog?app_key=631dd7b4-62bf-4dbe-93be-7eef30922bc4" as String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //EZLoadingActivity.show("Loading...", disableUI: false) // Show loading msg
        
        self.getLogData(firstLoad: true) // Get log info from Alfred
    }

    //MARK: Private Methods
    func getLogData(firstLoad: Bool) {
        var tmpURL = "" as String
        if firstLoad {
            tmpURL = logURL + "&reverse=true"
        } else {
            tmpURL = logURL + "&page=" + String(viewPage)
        }
        let url = URL(string: tmpURL)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            if error != nil {
                print ("Log File - Unable to get data")
                let alertController = UIAlertController(title: "Alfred", message:
                    "Unable to retrieve log data. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alertController, animated: true, completion: nil)
            } else {
                guard let data = data, error == nil else { return }
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                    let apiStatus = jsonObj["code"] as? String
                
                    if apiStatus == "sucess" {
                        
                        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                        let jsonData = json["data"] as! [String:Any]
                        let logData = jsonData["logs"] as! [NSDictionary]
                    
                        self.viewPage = jsonData["currentpage"] as! Int
                    
                        for item in logData {
                            self.logFileData.append(LogFileData(json: item))
                        }
                        
                        DispatchQueue.main.async() {
                            self.tableView.reloadData() // Refresh the table view
                            //if firstLoad {
                            //    EZLoadingActivity.hide(true, animated: true) // Hide loading msg
                            //}
                        }
                    } else {
                        let alertController = UIAlertController(title: "Alfred", message:
                            "Unable to retrieve log data. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                        self.present(alertController, animated: true, completion: nil)
                    }
                } catch {
                    let alertController = UIAlertController(title: "Alfred", message:
                        "Unable to retrieve log data. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }).resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logFileData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogFileTableViewCell") as! LogFileTableViewCell

        let row = indexPath.row

        if logFileData[row].level == "info" {
            cell.infoImage.image = UIImage(named: "Information-icon.png")
        } else {
            cell.infoImage.image = UIImage(named: "error-icon.png")
        }
        cell.messagelabel.text = logFileData[row].message
        cell.datelabel.text = logFileData[row].timestamp
        
        if indexPath.row == logFileData.count - 1 { // if last cell check if there is more data to load
            if viewPage > 1 {
                self.viewPage -= 1
                getLogData(firstLoad: false) // Load more data
            }
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
