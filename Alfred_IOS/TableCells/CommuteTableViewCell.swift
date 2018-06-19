//
//  CommuteTableViewCell.swift
//  Alfred_IOS
//
//  Created by John Pillar on 30/03/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit

class CommuteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lineType: UIImageView!
    @IBOutlet weak var Summary: UILabel!
    @IBOutlet weak var DepartTime: UILabel!
    @IBOutlet weak var Duration: UILabel!
    @IBOutlet weak var Distruptions: UIImageView!
    
    func configureWithItem(item: CommuteLegs) {
    
        switch(item.mode?.id) {
            case "national-rail" :
                lineType.image = #imageLiteral(resourceName: "ic_train")
                break;
            case "tube" :
                lineType.image = #imageLiteral(resourceName: "ic_tube")
                break;
            case "bus" :
                lineType.image = #imageLiteral(resourceName: "ic_bus")
                break;
            case "walking" :
                lineType.image = #imageLiteral(resourceName: "ic_walk")
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
            Distruptions.image = #imageLiteral(resourceName: "ic_bad")
        }
    }
    
}
