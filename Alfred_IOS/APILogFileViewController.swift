//
//  APILogFileViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 12/09/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class APILogFileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var LogFileTableView: UITableView!
    
    var logs = [Logs]()
    var viewPage = 1 as Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LogFileTableView.backgroundView = UIImageView(image: UIImage(named: "background.jpg"))
        
        LogFileTableView.addSubview(self.refreshControl) // Add pull to refresh functionality
        
        self.getData() // Get log info from Alfred
        
    }
    
    //MARK: Private Methods
    func getData() {
        
        DispatchQueue.global(qos: .userInitiated).async {

            let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
            let AlfredAppKey = readPlist(item: "AlfredAppKey")
            let url = URL(string: AlfredBaseURL + "displaylog" + AlfredAppKey + "&page=" + String(self.viewPage))!
            let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                guard let data = data, error == nil else { // Check for fundamental networking error
                     DispatchQueue.main.async {
                        // Show error
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showError(withStatus: "Network/API connection error")
                    }
                    return
                }

                let json = JSON(data: data)
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
                     DispatchQueue.main.async {
                        self.LogFileTableView.reloadData() // Refresh the table view
                    }
                } else {
                     DispatchQueue.main.async {
                        // Update the UI
                        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                        SVProgressHUD.showError(withStatus: "NUnable to retrieve logfile data")
                    }
                }
            })
            task.resume()
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(LogFileViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
        
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        logs = [Logs]() // clear the local store
        self.getData() // Get data
        refreshControl.endRefreshing() // Stop the pull to refresh UI
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop spinner
        SVProgressHUD.dismiss()
    }
}

    
    
