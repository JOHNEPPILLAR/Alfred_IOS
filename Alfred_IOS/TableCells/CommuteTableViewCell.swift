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
    @IBOutlet weak var Summary: UILabel!
    @IBOutlet weak var DepartTime: UILabel!
    @IBOutlet weak var Duration: UILabel!
    @IBOutlet weak var Distruptions: UIImageView!
    
    var DistruptionText:String!
    
    func configureWithItem(item: CommuteLegs) {
        if item.status == "No trains running" {
            DepartTime.isHidden = true
            Duration.isHidden = true
            Summary.frame.origin = CGPoint(x: 54, y: 25)
            Summary.text = item.status
            lineType.image = #imageLiteral(resourceName: "ic_travel_train")
        } else {
            DepartTime.isHidden = false
            Duration.isHidden = false
            Summary.frame.origin = CGPoint(x: 54, y: 35)
            Distruptions.image = nil
            switch(item.mode!) {
                case "train" :
                    lineType.image = #imageLiteral(resourceName: "ic_travel_train")
                    if item.line == "Thameslink" { lineType.image = #imageLiteral(resourceName: "ic_travel_crossrail") }
                    Summary.text = item.departureStation! + " to " + item.arrivalStation!
                    break;
                case "tube" :
                    lineType.image = #imageLiteral(resourceName: "ic_travel_underground")
                    Summary.text = item.line! + " from " + item.departureStation! + " to " + item.arrivalStation!
                    break;
                case "bus" :
                    lineType.image = #imageLiteral(resourceName: "ic_travel_bus")
                    break;
                case "walk" :
                    lineType.image = #imageLiteral(resourceName: "ic_walk")
                    Summary.text = item.departureStation! + " to " + item.arrivalStation!
                    break;
                case "dlr" :
                    lineType.image = #imageLiteral(resourceName: "ic_travel_dlr")
                    break;
                case "river-bus" :
                    lineType.image = #imageLiteral(resourceName: "ic_travel_river")
                    break;
                case "tram" :
                    lineType.image = #imageLiteral(resourceName: "ic_travel_tram")
                    break;
                case "overground" :
                    lineType.image = #imageLiteral(resourceName: "ic_travel_overground")
                    break;
                default:
                    lineType.image = #imageLiteral(resourceName: "ic_question_mark")
            }
            
            DepartTime.text = item.departureTime! + " - " + item.arrivalTime!
            Duration.text = "(" +  "\(item.duration!)" + " min)"
        }
        if item.disruptions == "true" { Distruptions.image = #imageLiteral(resourceName: "ic_info") }
    }

    @objc func showDistruptionInfo(sender : UITapGestureRecognizer) {
        print(DistruptionText)
        // SVProgressHUD.show(withStatus: cell.DistruptionText.text)
    }
}
