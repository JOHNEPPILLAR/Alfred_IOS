//
//  CommuteTableViewCell.swift
//  Alfred_IOS
//
//  Created by John Pillar on 30/03/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit

class CommuteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commuteType: UIImageView!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    
    func configureWithItem(item: CommuteCommuteResults) {
        switch item.mode {
        case "train"?  :
            commuteType.image = UIImage(named: "ic_train")
            destination.text = item.destination
            if item.disruptions == "true" {
                arrivalTime.textColor = UIColor.red
                arrivalTime.text = "Disruptions"
            } else {
                arrivalTime.text = item.firstTime! + " & " + item.secondTime!
            }
        case "bus"?  :
            commuteType.image = UIImage(named: "ic_bus")
            destination.text = item.line! + " to " + item.destination!
            if item.disruptions == "true" {
                arrivalTime.textColor = UIColor.red
                arrivalTime.text = "Disruptions"
            } else {
                arrivalTime.text = item.firstTime! + " & " + item.secondTime!
            }
        case "tube"?  :
            commuteType.image = UIImage(named: "ic_tube")
            destination.text = item.line! + " line"
            if item.disruptions == "true" {
                arrivalTime.textColor = UIColor.red
                arrivalTime.text = "Disruptions"
            } else {
                arrivalTime.text = "No disruptions"
            }
        default :
            commuteType.image = nil
            destination.text = ""
            arrivalTime.text = ""
        }
    }
    
}
