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

    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var commuteTableView: UITableView!
    
    fileprivate var CommuteDataArray = [CommuteResults]() {
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
        whoIsThis = defaults.string(forKey: "who_is_this")
        if (whoIsThis == nil) {
            whoIsThis = ""
            SVProgressHUD.showInfo(withStatus: "Please setup the app user defaults in settings")
        } else {
            if whoIsThis == "JP" { walkButton.isHidden = false }
            walking = false
            getCommuteData()
        }
        self.commuteTableView?.rowHeight = 70
        
        // Add walking button action
        walkButton.addTarget(self, action: #selector(getCommuteData), for: .touchUpInside)
    }
    
    @objc func getCommuteData() {
        if walking {
            walking = false
            walkButton.setImage(UIImage(named: "ic_walk_red"), for: UIControlState.normal)
        } else {
            walking = true
            walkButton.setImage(UIImage(named: "ic_walk_green"), for: UIControlState.normal)
        }
        SVProgressHUD.show(withStatus: "Loading")
        commuteController.getCommuteData(whoIsThis: whoIsThis!, walk: walking)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss() // Stop spinner
    }
}

extension CommuteViewController: UITableViewDelegate {
}

extension CommuteViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if CommuteDataArray.count > 0 {
            return CommuteDataArray[0].journeys!.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CommuteDataArray.count > 0 {
            return CommuteDataArray[0].journeys![section].legs!.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 51/255.0, green: 84/255.0, blue: 138/255.0, alpha: 1.0)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var StartDatetime = CommuteDataArray[0].journeys![section].startDateTime!
        var tempStartDatetime = StartDatetime.dropLast(3)
        StartDatetime = String(tempStartDatetime)
        tempStartDatetime = StartDatetime.dropFirst(11)
        StartDatetime = String(tempStartDatetime)

        var EndDatetime = CommuteDataArray[0].journeys![section].arrivalDateTime!
        var tempEndDatetime = EndDatetime.dropLast(3)
        StartDatetime = String(tempEndDatetime)
        tempEndDatetime = StartDatetime.dropFirst(11)
        EndDatetime = String(tempEndDatetime)

        var titleText = "Journey " + "\(section + 1)"
            titleText = titleText + ": " + tempStartDatetime
            titleText = titleText + " - " + tempEndDatetime
            titleText = titleText + " (" + String(CommuteDataArray[0].journeys![section].duration!) + " minutes)"

        return titleText
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commuteCell", for: indexPath) as! CommuteTableViewCell
        
        let item = CommuteDataArray[0].journeys![indexPath.section].legs![indexPath.item]
        cell.configureWithItem(item: item)
        return cell
    }
}

extension CommuteViewController: CommuteViewControllerDelegate {
    func didFailDataUpdateWithError() {
        SVProgressHUD.showError(withStatus: "Network/API error")
    }

    func cummuteDidRecieveDataUpdate(data: [CommuteResults]) {
        CommuteDataArray = data
    }
}
