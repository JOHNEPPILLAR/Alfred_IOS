//
//  SunriseViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 26/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON
import BRYXBanner

class SunriseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var morningData = [Morning]()
    
    @IBOutlet weak var LightTableViewMorning: UITableView!
    
    @IBOutlet weak var TableView: UITableView!
    @IBAction func turnOnHRStepper(_ sender: UIStepper) {
        turnOnHRLabel.text = Int(sender.value).description
        morningData[0].onHr = Int(sender.value)
    }
    @IBOutlet weak var turnOnHRStepper: UIStepper!
    @IBOutlet weak var turnOnHRLabel: UILabel!
    
    @IBAction func turnOnMINStepper(_ sender: UIStepper) {
        turnOnMINLabel.text = Int(sender.value).description
        morningData[0].onMin = Int(sender.value)
    }
    @IBOutlet weak var turnOnMINStepper: UIStepper!
    @IBOutlet weak var turnOnMINLabel: UILabel!
    
    @IBAction func turnOffHRStepper(_ sender: UIStepper) {
        turnOffHRLabel.text = Int(sender.value).description
        morningData[0].offHr = Int(sender.value)
    }
    @IBOutlet weak var turnOffHRStepper: UIStepper!
    @IBOutlet weak var turnOffHRLabel: UILabel!
    
    @IBAction func turnOffMINStepper(_ sender: UIStepper) {
        turnOffMINLabel.text = Int(sender.value).description
        morningData[0].offMin = Int(sender.value)
    }
    @IBOutlet weak var turnOffMINStepper: UIStepper!
    @IBOutlet weak var turnOffMINLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add save button to navigation bar
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveSettingsAction(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        
        // Disable UI controls untill data is loaded
        navigationItem.rightBarButtonItem?.isEnabled = false
        self.turnOnHRStepper.isEnabled = false
        self.turnOnHRStepper.isEnabled = false
        self.turnOnHRStepper.isEnabled = false
        self.turnOffHRStepper.isEnabled = false
        
        // Get sunset configuration info from Alfred
        self.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Private Methods
    func getData() {
        
        let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
        let AlfredAppKey = readPlist(item: "AlfredAppKey")
        let url = URL(string: AlfredBaseURL + "settings/view" + AlfredAppKey)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                // Update the UI
                DispatchQueue.main.async() {
                    
                    let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to retrieve settings. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                    banner.dismissesOnTap = true
                    banner.show()
                    
                }
                
            } else {
                
                guard let data = data, error == nil else { return }
                let json = JSON(data: data)
                let apiStatus = json["code"]
                let apiStatusString = apiStatus.string!
                
                if apiStatusString == "sucess" {
                    
                    // Save json to custom classes
                    let jsonData = json["data"]["morning"]
                    self.morningData = [Morning(json: jsonData)]
                    
                    DispatchQueue.main.async() {
                        
                        // Setup the offset and off timer settings
                        self.turnOnHRLabel.text = String(self.morningData[0].onHr!)
                        self.turnOnHRStepper.value = Double(self.morningData[0].onHr!)
                        self.turnOnMINLabel.text = String(self.morningData[0].onMin!)
                        self.turnOnMINStepper.value = Double(self.morningData[0].onMin!)
                        
                        self.turnOffHRLabel.text = String(self.morningData[0].offHr!)
                        self.turnOffHRStepper.value = Double(self.morningData[0].offHr!)
                        
                        self.turnOffMINLabel.text = String(self.morningData[0].offMin!)
                        self.turnOffMINStepper.value = Double(self.morningData[0].offMin!)
                        
                        // Enable UI controls
                        self.turnOnHRStepper.isEnabled = true
                        self.turnOnMINStepper.isEnabled = true
                        self.turnOffHRStepper.isEnabled = true
                        self.turnOffMINStepper.isEnabled = true
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                        
                        // Refresh the table view
                        self.LightTableViewMorning.reloadData()

                    }
                } else {
                    
                    // Update the UI
                    DispatchQueue.main.async() {
                        
                        let banner = Banner(title: "Alfred API Notification", subtitle: "Unable to retrieve settings. Please try again.", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
                        banner.dismissesOnTap = true
                        banner.show()
                        
                    }
                }
            }
        }).resume()
    }
  
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (morningData.count) > 0 {
            return (morningData[0].lights?.count)!
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LightTableViewCellMorning") as! LightTableViewCell
        let row = indexPath.row
        
        // Tag colour button so can referance it later if needed
        cell.tag = indexPath.row
        
        // Populate the cell elements
        cell.LightNameLabelMorning.text = morningData[0].lights?[row].lightName

        if morningData[0].lights?[row].onoff == "on" {
            cell.onOffSwitchMorning.setOn(true, animated:true)
        } else {
            cell.onOffSwitchMorning.setOn(false, animated:true)
        }
        cell.LightBrightnessSliderMorning.setValue(Float((morningData[0].lights?[row].brightness)!), animated: true)

        // Get RGB colour for button background
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        let color = UIColor(red: CGFloat((morningData[0].lights?[row].red)!)/255.0, green: CGFloat((morningData[0].lights?[row].green)!)/255.0, blue: CGFloat((morningData[0].lights?[row].blue)!)/255.0, alpha: 1.0)
        
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
            cell.ColorButtonMorning.backgroundColor = color
        } else {
            cell.ColorButtonMorning.isHidden = true
        }
        
        return cell

    }
    
    func saveSettingsAction(sender: UIBarButtonItem)
    {
        print("Saving... TO DO ...")
        
    }
}
