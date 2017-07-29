//
//  LightsTableViewCell.swift
//  Alfred_IOS
//
//  Created by John Pillar on 29/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit

class LightsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lightName: UILabel!
    @IBOutlet weak var lightSwitch: UISwitch!
    @IBOutlet weak var lightBrightness: UISlider!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
