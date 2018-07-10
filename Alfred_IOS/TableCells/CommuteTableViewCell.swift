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
    
    var DistruptionText:String!
    
    func configureWithItem(item: CommuteLegs) {
        if item.status == "No trains running" {
            lineType.image = #imageLiteral(resourceName: "ic_travel_train")
            Summary1.isHidden = true
            Summary2.frame.origin = CGPoint(x: 54, y: 25)
            Summary2.text = item.status
        } else {
            Summary1.isHidden = false
            Summary2.frame.origin = CGPoint(x: 54, y: 35)
            Summary2.isHidden = false
            Distruptions.image = nil
            switch(item.mode!) {
                case "train" :
                    lineType.image = #imageLiteral(resourceName: "ic_travel_train")
                    if item.line == "Thameslink" { lineType.image = #imageLiteral(resourceName: "ic_travel_crossrail") }
                    Summary1.text = item.departureTime! + "-" + item.arrivalTime! + " (" + "\(item.duration!)" + " min) (" + item.status! + ")"
                    Summary2.text = item.departureStation! + " (pl " + item.departurePlatform! + ") to " + item.arrivalStation!
                    break;
                case "tube" :
                    lineType.image = #imageLiteral(resourceName: "ic_travel_underground")
                    Summary1.text = item.departureTime! + "-" + item.arrivalTime! + " " + " (" +  "\(item.duration!)" + " min)"
                    Summary2.text = item.line! + " from " + item.departureStation! + " to " + item.arrivalStation!
                    break;
                case "bus" :
                    lineType.image = #imageLiteral(resourceName: "ic_travel_bus")
                    break;
                case "walk" :
                    Summary1.text = item.departureTime! + "-" + item.arrivalTime! + " (" +  "\(item.duration!)" + " min)"
                    Summary2.text = item.departureStation! + " to " + item.arrivalStation!
                    lineType.image = #imageLiteral(resourceName: "ic_walk")
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
        }
        if item.disruptions == "true" { Distruptions.image = #imageLiteral(resourceName: "ic_info") }
    }

    @objc func showDistruptionInfo(sender : UITapGestureRecognizer) {
        print(DistruptionText)
        // SVProgressHUD.show(withStatus: cell.DistruptionText.text)
    }
}
