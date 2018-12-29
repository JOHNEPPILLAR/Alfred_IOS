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
    var whoIsThis:String!
    var walking:Bool!

    @IBOutlet weak var commuteTableView: UITableView!
    
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.commuteTableView?.rowHeight = 130.0
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")

        // Check the user defaults
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
        let defaults = UserDefaults.standard
        whoIsThis = defaults.string(forKey: "who_is_this")
        if (whoIsThis == nil) {
            whoIsThis = ""
            SVProgressHUD.showInfo(withStatus: "Please setup the app user defaults in settings")
        } else {
            getCommuteData()
        }
        self.commuteTableView?.rowHeight = 165        
    }
    
    @objc func getCommuteData() {
        SVProgressHUD.show(withStatus: "Loading")
        commuteController.getCommuteData(whoIsThis: whoIsThis!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss() // Stop spinner
    }
}

extension CommuteViewController: UITableViewDelegate {
}

extension CommuteViewController: UITableViewDataSource {

    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        return CommuteDataArray.count
    }
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CommuteDataArray.count > 0 {
            return CommuteDataArray[0].journeys?[0].legs?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 51/255.0, green: 84/255.0, blue: 138/255.0, alpha: 1.0)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var titleText = ""
        if section == 0 {
            titleText = "Primary"
        } else {
            titleText = "Alternative #" + "\(section)"
        }

        let status = (CommuteDataArray[0].journeys![section].legs![0].status != nil) ? CommuteDataArray[0].journeys![section].legs![0].status! : "error"

        if status == "error" {
            titleText = "No train data available"
            return titleText
        }

        if status == "No trains running" {
            titleText = "No trains are running"
            return titleText
        }

        let StartDatetime = (CommuteDataArray[0].journeys![section].legs![0].departureTime != nil) ? CommuteDataArray[0].journeys![section].legs![0].departureTime : "N/A"

        var endLeg = CommuteDataArray[0].journeys![section].legs?.count != nil ? CommuteDataArray[0].journeys![section].legs?.count : 0
        if endLeg! > 0 { endLeg = endLeg! - 1 }
        
        
        let EndDatetime = (CommuteDataArray[0].journeys![section].legs![endLeg!].arrivalTime != nil) ? CommuteDataArray[0].journeys![section].legs![endLeg!].arrivalTime : "N/A"
            
        titleText = titleText + ": " + StartDatetime! + " - " + EndDatetime!
        return titleText
    }
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commuteCell", for: indexPath) as! CommuteTableViewCell
        let item = CommuteDataArray[0].journeys?[0].legs?[indexPath.item]
        cell.configureWithItem(item: item!)
        return cell
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
