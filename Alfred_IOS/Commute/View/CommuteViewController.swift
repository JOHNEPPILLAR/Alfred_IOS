//
//  CommuteViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 04/11/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class CommuteViewController: UIViewController {

    private let commuteController = CommuteController()

    @IBOutlet weak var commuteTableView: UITableView!
    @IBOutlet weak var arrivalTime: UILabel!
    fileprivate var CommuteDataArray = [CommuteData]() {
        didSet {
            commuteTableView?.reloadData()
            SVProgressHUD.dismiss() // Stop spinner
        }
    }
    
    @IBAction func returnToPreviousView(_ sender: UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commuteTableView?.delegate = self
        commuteTableView?.dataSource = self
        commuteController.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.commuteTableView?.rowHeight = 120.0
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")

        // Check the user defaults
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
        let defaults = UserDefaults.standard
        var whoIsThis = defaults.string(forKey: "who_is_this")
        if (whoIsThis == nil) {
            whoIsThis = ""
            SVProgressHUD.showInfo(withStatus: "Please setup the app user defaults in settings")
        } else {
            commuteController.getCommuteData(whoIsThis: whoIsThis!) // Commute data
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss() // Stop spinner
    }
}

extension CommuteViewController: UITableViewDelegate {
}

extension CommuteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commuteCell", for: indexPath) as! CommuteTableViewCell
        cell.configureWithItem(item: CommuteDataArray[0].commuteResults![indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CommuteDataArray.count > 0 {
           return CommuteDataArray[0].commuteResults!.count
        }
        return 0
    }
}


extension CommuteViewController: CommuteViewControllerDelegate {
    func didFailDataUpdateWithError() {
        SVProgressHUD.showError(withStatus: "Network/API error")
    }

    func cummuteDidRecieveDataUpdate(data: [CommuteData]) {
        CommuteDataArray = data
    }

}
