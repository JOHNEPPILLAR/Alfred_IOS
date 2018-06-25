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
    
        switch(item.mode?.id) {
            case "tfl-rail" :
                lineType.image = #imageLiteral(resourceName: "ic_travel_tflrail")
                break;
            case "national-rail" :
                lineType.image = #imageLiteral(resourceName: "ic_travel_train")
                break;
            case "tube" :
                lineType.image = #imageLiteral(resourceName: "ic_travel_underground")
                break;
            case "replacement-bus" :
                lineType.image = #imageLiteral(resourceName: "ic_travel_bus")
                break;
            case "bus" :
                lineType.image = #imageLiteral(resourceName: "ic_travel_bus")
                break;
            case "walking" :
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
            case "thameslink" :
                lineType.image = #imageLiteral(resourceName: "ic_travel_crossrail")
                break;
            default:
                lineType.image = #imageLiteral(resourceName: "ic_question_mark")
        }
        Summary.text = item.instruction?.summary
        var Datetime = item.departureTime
        var tempDatetime = Datetime?.dropLast(3)
        Datetime = String(tempDatetime!)
        tempDatetime = Datetime?.dropFirst(11)
        Datetime = String(tempDatetime!)
        DepartTime.text = Datetime
        Duration.text = "(" +  "\(item.duration!)" + " min)"
        
        if item.disruptions?.count != 0 {
            Distruptions.image = #imageLiteral(resourceName: "ic_info")
            dump(item.disruptions)

            //let tap = UITapGestureRecognizer(target: self, action: #selector(showDistruptionInfo))
            //Distruptions.addGestureRecognizer(tap)
            //Distruptions.isUserInteractionEnabled = true
        }
    }

    @objc func showDistruptionInfo(sender : UITapGestureRecognizer) {
print(DistruptionText)
        // SVProgressHUD.show(withStatus: cell.DistruptionText.text)
    }
}
