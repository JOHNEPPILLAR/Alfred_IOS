//
//  CommuteTableViewCell.swift
//  Alfred_IOS
//
//  Created by John Pillar on 30/03/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SVProgressHUD

class CommuteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lineType: UIImageView!
    @IBOutlet weak var Summary1: UILabel!
    @IBOutlet weak var Summary2: UILabel!
    @IBOutlet weak var Distruptions: UIImageView!
    
    func configureWithItem(item: CommuteLegs) {
        
        let mode = (item.mode != nil) ? item.mode! : ""
        let status = (item.status != nil) ? item.status! : ""
        let departurePlatform = (item.departurePlatform != nil) ? item.departurePlatform! : ""
        let arrivalStation = (item.arrivalStation != nil) ? item.arrivalStation! : ""
        let arrivalTime = (item.arrivalTime != nil) ? item.arrivalTime! : ""
        let disruptions = (item.disruptions != nil) ? item.disruptions! : ""
        let departureTime = (item.departureTime != nil) ? item.departureTime! : ""
        let departureStation = (item.departureStation != nil) ? item.departureStation! : ""
        let duration = (item.duration != nil) ? item.duration! : ""
        let line = (item.line != nil) ? item.line! : ""
        
        // If no results then alert and exit function
        if (mode == "train" && status == "No trains running") || mode == "error" {
            lineType.image = #imageLiteral(resourceName: "ic_travel_train")
            Summary1.isHidden = true
            Summary2.frame.origin = CGPoint(x: 54, y: 25)
            Summary2.text = status
            return
        }
        
        // Reset positions
        Summary1.isHidden = false
        Summary2.frame.origin = CGPoint(x: 54, y: 35)
        Summary2.isHidden = false
        Distruptions.image = nil

        // Process data
        switch(mode) {
            case "train" :
                lineType.image = #imageLiteral(resourceName: "ic_travel_train")
                if line == "Thameslink" { lineType.image = #imageLiteral(resourceName: "ic_travel_crossrail") }
                Summary1.text = departureTime + "-" + arrivalTime + " (" + duration
                Summary1.text = Summary1.text! + " min) (" + status + ")"
                Summary2.text = departureStation + " (pl " + departurePlatform + ") to " + arrivalStation
                break;
            case "tube" :
                lineType.image = #imageLiteral(resourceName: "ic_travel_underground")
                Summary1.text = departureTime + "-" + arrivalTime + " " + " (" + duration + " min)"
                Summary2.text = line + " from " + departureStation + " to " + arrivalStation
                break;
            case "bus" :
                lineType.image = #imageLiteral(resourceName: "ic_travel_bus")
                Summary1.text = ""
                Summary2.text = ""
                break;
            case "walk" :
                lineType.image = #imageLiteral(resourceName: "ic_walk")
                Summary1.text = departureTime + "-" + arrivalTime + " (" +  duration + " min)"
                Summary2.text = departureStation + " to " + arrivalStation
                break;
            // case "dlr" :
            //     lineType.image = #imageLiteral(resourceName: "ic_travel_dlr")
            //     break;
            // case "river-bus" :
            //     lineType.image = #imageLiteral(resourceName: "ic_travel_river")
            //     break;
            // case "tram" :
            //     lineType.image = #imageLiteral(resourceName: "ic_travel_tram")
            //     break;
            // case "overground" :
            //     lineType.image = #imageLiteral(resourceName: "ic_travel_overground")
            //     break;
            default:
                lineType.image = #imageLiteral(resourceName: "ic_question_mark")
                Summary1.text = ""
                Summary2.text = ""
            }
        
        if disruptions == "true" { Distruptions.image = #imageLiteral(resourceName: "ic_error") }
    }
}
