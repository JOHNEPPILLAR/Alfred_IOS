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
    @IBOutlet weak var StartTime: UILabel!
    @IBOutlet weak var DepartText: UILabel!
    @IBOutlet weak var Duration: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var EndTime: UILabel!
    @IBOutlet weak var ArriveText: UILabel!
    @IBOutlet weak var StartIcon: UIImageView!
    @IBOutlet weak var LineIcon: UIImageView!
    @IBOutlet weak var EndIcon: UIImageView!
    
    func configureWithItem(item: CommuteLegs) {
        
        let mode = (item.mode != nil) ? item.mode! : ""
        let status = (item.status != nil) ? item.status! : ""
        let departureTime = (item.departureTime != nil) ? item.departureTime! : ""
        var duration = (item.duration != nil) ? item.duration! : "0"
        duration = duration + " (min)"
        let arrivalTime = (item.arrivalTime != nil) ? item.arrivalTime! : ""
        var departurePlatform = (item.departurePlatform != nil) ? item.departurePlatform! : "- tbc"
        departurePlatform = "Platform " + departurePlatform
        let arrivalStation = (item.arrivalStation != nil) ? item.arrivalStation! : ""
        _ = (item.disruptions != nil) ? item.disruptions! : ""
        let departureStation = (item.departureStation != nil) ? item.departureStation! : ""
        let line = (item.line != nil) ? item.line! : ""

        // Process data
        switch(mode) {
            case "train" :
                lineType.image = #imageLiteral(resourceName: "ic_travel_train")
                if line == "Thameslink" { lineType.image = #imageLiteral(resourceName: "ic_travel_crossrail") }
                StartTime.text = departureTime
                DepartText.text = departureStation + " - " + departurePlatform
                Duration.text = duration
                Status.text = status
                EndTime.text = arrivalTime
                ArriveText.text = arrivalStation
                break;
            case "tube" :
                lineType.image = #imageLiteral(resourceName: "ic_travel_underground")
                StartTime.text = departureTime
                DepartText.text = departureStation
                Duration.text = duration
                Status.text = status
                EndTime.text = arrivalTime
                ArriveText.text = arrivalStation
                break;
            case "bus" :
                lineType.image = #imageLiteral(resourceName: "ic_travel_bus")
                StartTime.text = departureTime
                DepartText.text = departureStation
                Duration.text = duration
                Status.text = nil
                EndTime.text = arrivalTime
                ArriveText.text = arrivalStation
                break;
            case "walk" :
                lineType.image = #imageLiteral(resourceName: "ic_walk")
                StartTime.text = departureTime
                DepartText.text = departureStation
                Duration.text = duration
                Status.text = nil
                EndTime.text = arrivalTime
                ArriveText.text = arrivalStation
                break;
            case "error" :
                lineType.image = #imageLiteral(resourceName: "ic_error")
                StartTime.text = nil
                DepartText.text = nil
                Duration.text = nil
                Status.text = status
                EndTime.text = nil
                ArriveText.text = nil
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
                StartTime.text = nil
                DepartText.text = nil
                Duration.text = nil
                Status.text = nil
                EndTime.text = nil
                ArriveText.text = nil
            }
        
        if item.disruptions == "true" {
            StartIcon.image = #imageLiteral(resourceName: "ic_start_end")
            LineIcon.image = #imageLiteral(resourceName: "ic_line_red")
            EndIcon.image = #imageLiteral(resourceName: "ic_end_red")
        }
    }
}
