//
//  SensorsViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 30/09/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class ViewSensorsController: UIViewController {

    private let sensorsController = SensorsController()
        
    var sensorID:Int = 0
        
    @IBOutlet weak var SensorsTableView: UITableView!
        
    fileprivate var SensorsDataArray = [SensorsData]() {
        didSet {
            SensorsTableView?.reloadData()
            SVProgressHUD.dismiss() // Stop spinner
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        SensorsTableView?.delegate = self
        SensorsTableView?.dataSource = self
        sensorsController.delegate = self
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        SensorsTableView.addSubview(self.refreshControl) // Add pull to refresh functionality
            
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")
            
        sensorsController.getSensorsData()
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
        sensorsController.getSensorsData() // Get data
        refreshControl.endRefreshing() // Stop the pull to refresh UI
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
//        if let vc = segue.destination as? ViewSensorController
//        {
//            vc.sensorID = sensorID
//        }
    }
}
    
extension ViewSensorsController: UITableViewDelegate {
}
    
extension ViewSensorsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SensorsTableViewCell", for: indexPath) as! SensorsTableViewCell
        cell.configureWithItem(item: SensorsDataArray[0].rows![indexPath.item])
        cell.backgroundColor = .clear
            
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 30/255, green: 24/255, blue: 60/255, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
            
        return cell
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (SensorsDataArray.count > 0) {
            return SensorsDataArray[0].rowCount!
        } else { return 0 }
    }
        
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.sensorID = editActionsForRowAt.row
            self.performSegue(withIdentifier: "sensor", sender: self)
        }
        edit.backgroundColor = .lightGray
            
        return [edit]
    }
        
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
        
}
    
extension ViewSensorsController: SensorsControllerDelegate {
    func didFailDataUpdateWithError() {
        SVProgressHUD.showError(withStatus: "Network/API error")
    }
        
    func sensorsDidRecieveDataUpdate(data: [SensorsData]) {
        SensorsDataArray = data
            
        // Reposition view to top of table
        SensorsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: false)
    }
        
}
