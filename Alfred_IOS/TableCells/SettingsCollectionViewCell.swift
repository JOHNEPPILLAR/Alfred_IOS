//
//  SettingsCollectionViewCell.swift
//  Alfred_IOS
//
//  Created by John Pillar on 24/06/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var callImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!

    func configureWithItem(item: JSON) {
        cellLabel.text =  item["label"].string
        callImage.image = UIImage(named: (item["image"].string)!)
    }
}
