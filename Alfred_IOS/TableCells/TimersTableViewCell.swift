//
//  TimersTableViewCell.swift
//  Alfred_IOS
//
//  Created by John Pillar on 09/09/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit

class TimersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timerNameLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var ai_image: UIImageView!
    @IBOutlet weak var active_image: UIImageView!
    
    func configureWithItem(item: TimersRows) {

        timerNameLabel.text = item.name

        let paddedHour =  String(format: "%02d", item.hour!)
        let minute =  "\(item.minute ?? 0)"
        let paddedMinute = minute.padding(toLength: 2, withPad: "0", startingAt: 0)

        timerLabel.text = paddedHour + ":" + paddedMinute
        
        ai_image.isHidden = false
        if !(item.aiOverride)! { ai_image.isHidden = true }
        
        active_image.image = #imageLiteral(resourceName: "ic_good")
        if !(item.active)! { ai_image.image = #imageLiteral(resourceName: "ic_bad") }
    }
}