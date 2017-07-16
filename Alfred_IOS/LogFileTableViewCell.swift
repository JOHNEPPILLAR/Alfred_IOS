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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
