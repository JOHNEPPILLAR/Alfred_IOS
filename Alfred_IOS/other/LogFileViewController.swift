//
//  LogFileViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 05/08/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class LogFileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!) )
    }
    
    @IBOutlet weak var LogFileTableView: UITableView!
    
    var logs = [Logs]()
    var viewPage = 1 as Int
    var onLastPage = false as Bool

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")

        LogFileTableView.backgroundView = UIImageView(image: UIImage(named: "background.jpg"))
        LogFileTableView.addSubview(self.refreshControl) // Add pull to refresh functionality
        
        self.getData() // Get log info from Alfred
    }

    func getData() {        

        if !self.onLastPage {

            // Call Alfred to get log file contents
            let request = getAPIHeaderData(url: "displaylog?page=" + String(self.viewPage), useScheduler: true)
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue:OperationQueue.main)
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                if checkAPIData(apiData: data, response: response, error: error) {
                    
                    let json = JSON(data: data!)
                    let logData = json["data"]
                    let currentpagejson = logData["currentpage"]
                    self.viewPage = currentpagejson.int!
                    let lastpagejson = logData["lastpage"]
                    if currentpagejson == lastpagejson {
                        self.onLastPage = true
                    }
                    
                    for item in logData["logs"] {
                        self.logs.append(Logs(json: item.1))
                    }
                    
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss() // Dismiss the loading HUD
                        self.LogFileTableView.reloadData() // Refresh the table view
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
        SVProgressHUD.dismiss() // Stop spinner
    }
}