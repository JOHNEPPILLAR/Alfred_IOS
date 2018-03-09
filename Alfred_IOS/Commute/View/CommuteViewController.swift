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

    @IBAction func returnToPreviousView(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var part1Image: UIImageView!
    @IBOutlet weak var part1Line: UILabel!
    @IBOutlet weak var part1Time: UILabel!

    @IBOutlet weak var part2Image: UIImageView!
    @IBOutlet weak var part2Line: UILabel!
    @IBOutlet weak var part2Time: UILabel!

    @IBOutlet weak var part3Image: UIImageView!
    @IBOutlet weak var part3Line: UILabel!
    @IBOutlet weak var part3Time: UILabel!
    
    @IBOutlet weak var part4Image: UIImageView!
    @IBOutlet weak var part4Line: UILabel!
    @IBOutlet weak var part4Time: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commuteController.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading")

        // Check the user defaults
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
        let defaults = UserDefaults.standard
        let whoIsThis = defaults.string(forKey: "who_is_this")
        if (whoIsThis != nil){
            commuteController.getCommuteData(whiIsThis: whoIsThis!) // Commute data
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss() // Stop spinner
    }
}

extension CommuteViewController: CommuteViewControllerDelegate {
    func didFailDataUpdateWithError() {
        SVProgressHUD.showError(withStatus: "Network/API error")
    }

    func cummuteDidRecieveDataUpdate(data: [CommuteData]) {
        
        // First commute option
        switch data[0].part1?.mode {
        case "train"?  :
            self.part1Image.image = UIImage(named: "ic_train")
            self.part1Line.text = data[0].part1?.destination
            self.part1Time.text = (data[0].part1?.firstTime)! + " & " + (data[0].part1?.secondTime)!
        case "bus"?  :
            self.part1Image.image = UIImage(named: "ic_bus")
            self.part1Line.text = (data[0].part1?.line)! + " to " + (data[0].part1?.destination)!
            self.part1Time.text = (data[0].part1?.firstTime)! + " & " + (data[0].part1?.secondTime)!
        case "tube"?  :
            self.part1Image.image = UIImage(named: "ic_tube")
            self.part1Line.text = (data[0].part1?.line)! + " Line"
            self.part1Time.text = "No disruptions"
        default :
            self.part1Image.image = nil
        }
        
        if !((data[0].part1?.disruptions) != nil) {
            self.part1Line.textColor = UIColor.red
            self.part1Time.textColor = UIColor.red
            self.part1Time.text = "Disruptions"
        }

        
        // Second commute option
        switch data[0].part2?.mode {
        case "train"?  :
            self.part2Image.image = UIImage(named: "ic_train")
            self.part2Line.text = data[0].part2?.destination
            self.part2Time.text = (data[0].part2?.firstTime)! + " & " + (data[0].part2?.secondTime)!
        case "bus"?  :
            self.part2Image.image = UIImage(named: "ic_bus")
            self.part2Line.text = (data[0].part2?.line)! + " to " + (data[0].part2?.destination)!
            self.part2Time.text = (data[0].part2?.firstTime)! + " & " + (data[0].part2?.secondTime)!
        case "tube"?  :
            self.part2Image.image = UIImage(named: "ic_tube")
            self.part2Line.text = (data[0].part2?.line)! + " Line"
            self.part2Time.text = "No disruptions"
        default :
            self.part2Image.image = nil
        }
        
        if !((data[0].part2?.disruptions) != nil) {
            self.part2Line.textColor = UIColor.red
            self.part2Time.textColor = UIColor.red
            self.part2Time.text = "Disruptions"
        }

        // Third commute option
        switch data[0].part3?.mode {
        case "train"?  :
            self.part3Image.image = UIImage(named: "ic_train")
            self.part3Line.text = data[0].part3?.destination
            self.part3Time.text = (data[0].part3?.firstTime)! + " & " + (data[0].part3?.secondTime)!
        case "bus"?  :
            self.part3Image.image = UIImage(named: "ic_bus")
            self.part3Line.text = (data[0].part3?.line)! + " to " + (data[0].part3?.destination)!
            self.part3Time.text = (data[0].part3?.firstTime)! + " & " + (data[0].part3?.secondTime)!
        case "tube"?  :
            self.part3Image.image = UIImage(named: "ic_tube")
            self.part3Line.text = (data[0].part3?.line)! + " Line"
            self.part3Time.text = "No disruptions"
        default :
            self.part3Image.image = nil
        }
        
        if !((data[0].part3?.disruptions) != nil) {
            self.part3Line.textColor = UIColor.red
            self.part3Time.textColor = UIColor.red
            self.part3Time.text = "Disruptions"
        }
        
        // Forth commute option
        switch data[0].part4?.mode {
        case "train"?  :
            self.part4Image.image = UIImage(named: "ic_train")
            self.part4Line.text = data[0].part4?.destination
            self.part4Time.text = (data[0].part4?.firstTime)! + " & " + (data[0].part4?.secondTime)!
        case "bus"?  :
            self.part4Image.image = UIImage(named: "ic_bus")
            self.part4Line.text = (data[0].part4?.line)! + " to " + (data[0].part4?.destination)!
            self.part4Time.text = (data[0].part4?.firstTime)! + " & " + (data[0].part4?.secondTime)!
        case "tube"?  :
            self.part4Image.image = UIImage(named: "ic_tube")
            self.part4Line.text = (data[0].part4?.line)! + " Line"
            self.part4Time.text = "No disruptions"
        default :
            self.part4Image.image = nil
        }
        
        if !((data[0].part4?.disruptions) != nil) {
            self.part4Line.textColor = UIColor.red
            self.part4Time.textColor = UIColor.red
            self.part4Time.text = "Disruptions"
        }
        SVProgressHUD.dismiss() // Dismiss the loading HUD
    }

}
