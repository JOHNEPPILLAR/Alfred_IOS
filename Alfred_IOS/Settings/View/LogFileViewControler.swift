//
//  LogFileViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 12/09/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class ViewLogsController: UIViewController {
    
    private let logsController = LogsController()
    
    @IBOutlet weak var LogFileTableView: UITableView!

    fileprivate var LogsDataArray = [LogsData]() {
        didSet {
            LogFileTableView?.reloadData()
            SVProgressHUD.dismiss() // Stop spinner
        }
    }
    
    var viewPage = 1 as Int
    var onLastPage = false as Bool
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogFileTableView?.delegate = self
        LogFileTableView?.dataSource = self
        logsController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LogFileTableView.addSubview(self.refreshControl) // Add pull to refresh functionality
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")
        
        logsController.getLogData(page: viewPage)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss() // Stop spinner
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        logsController.getLogData(page: viewPage) // Get data
        refreshControl.endRefreshing() // Stop the pull to refresh UI
    }
}

extension ViewLogsController: UITableViewDelegate {
}

extension ViewLogsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogFileTableViewCell", for: indexPath) as! LogFileTableViewCell
        cell.configureWithItem(item: LogsDataArray[indexPath.item])
        cell.backgroundColor = .clear
        
        //if indexPath.row == logs.count - 1 { // if last cell check if there is more data to load
        //    if !self.onLastPage {
        //        self.viewPage += 1
        //        getData() // Load more data
        //    }
        //}

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LogsDataArray.count
    }
}

extension ViewLogsController: LogsControllerDelegate {
    func didFailDataUpdateWithError() {
        SVProgressHUD.showError(withStatus: "Network/API error")
    }
    
    func logsDidRecieveDataUpdate(data: [LogsData]) {
        LogsDataArray = data
      
        // Reposition view to top of table
        super.viewWillAppear(true)
        LogFileTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: false)
    }
    
}
