//
//  TimersViewControler.swift
//  Alfred_IOS
//
//  Created by John Pillar on 09/09/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class ViewTimersController: UIViewController {
    
    private let timersController = TimersController()
    
    var timerID:Int = 0
    
    @IBOutlet weak var TimersTableView: UITableView!
    
    fileprivate var TimersDataArray = [TimersData]() {
        didSet {
            TimersTableView?.reloadData()
            SVProgressHUD.dismiss() // Stop spinner
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TimersTableView?.delegate = self
        TimersTableView?.dataSource = self
        timersController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TimersTableView.addSubview(self.refreshControl) // Add pull to refresh functionality
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")
        
        timersController.getTimerData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss() // Stop spinner
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        timersController.getTimerData() // Get data
        refreshControl.endRefreshing() // Stop the pull to refresh UI
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? ViewTimerController
        {
            vc.timerID = timerID
        }
    }
}

extension ViewTimersController: UITableViewDelegate {
}

extension ViewTimersController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimersTableViewCell", for: indexPath) as! TimersTableViewCell
        cell.configureWithItem(item: TimersDataArray[0].rows![indexPath.item])
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 30/255, green: 24/255, blue: 60/255, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (TimersDataArray.count > 0) {
            return TimersDataArray[0].rowCount!
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.timerID = editActionsForRowAt.row
            self.performSegue(withIdentifier: "timer", sender: self)
        }
        edit.backgroundColor = .lightGray
        
        return [edit]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension ViewTimersController: TimersControllerDelegate {
    func didFailDataUpdateWithError() {
        SVProgressHUD.showError(withStatus: "Network/API error")
    }
    
    func timersDidRecieveDataUpdate(data: [TimersData]) {
        TimersDataArray = data
        
        // Reposition view to top of table
        TimersTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: false)
    }
    
}
