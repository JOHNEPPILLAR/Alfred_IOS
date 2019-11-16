//
//  ScheduleTableViewCell.swift
//  Alfred_IOS
//
//  Created by John Pillar on 09/09/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var scheduleNameLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var ai_image: UIImageView!
    @IBOutlet weak var active_image: UIImageView!
    
    func configureWithItem(item: SchedulesData) {

        scheduleNameLabel.text = item.name

        let paddedHour =  String(format: "%02d", item.hour!)
        let minute =  "\(item.minute ?? 0)"
        let paddedMinute = minute.padding(toLength: 2, withPad: "0", startingAt: 0)

        scheduleLabel.text = paddedHour + ":" + paddedMinute
        
        ai_image.isHidden = false
        if !item.aiOverride! { ai_image.isHidden = true }
        
        active_image.image = #imageLiteral(resourceName: "ic_success")
        if !item.active! { active_image.image = #imageLiteral(resourceName: "ic_error") }
    }
 
}
