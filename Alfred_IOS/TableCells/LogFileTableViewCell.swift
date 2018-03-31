//
//  LogFileTableViewCell.swift
//  Alfred_IOS
//
//  Created by John Pillar on 10/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit

class LogFileTableViewCell: UITableViewCell {

    @IBOutlet weak var messagelabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var infoImage: UIImageView!
    
    func configureWithItem(item: LogLogs) {
        if item.level == "info" {
            infoImage.image = UIImage(named: "Information-icon.png")
        } else {
            infoImage.image = UIImage(named: "error-icon.png")
        }
        messagelabel.text = item.message
        datelabel.text = item.timestamp
    }
    
}
