//
//  LogFileTableViewCell.swift
//  Alfred_IOS
//
//  Created by John Pillar on 10/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit

class LogFileTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    
    func configureWithItem(item: LogsData) {
        if item.type == "error" {
            infoImage.image = #imageLiteral(resourceName: "ic_error")
        } else {
            infoImage.image = #imageLiteral(resourceName: "ic_info")
        }
        messageLabel.text = item.message
        serviceLabel.text = item.service! + " (" + item.functionName! + ")"
    }
    
}
