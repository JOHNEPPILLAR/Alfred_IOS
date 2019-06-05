//
//  GardenSensorsTableViewCell.swift
//  Alfred_IOS
//
//  Created by John Pillar on 04/06/2019.
//  Copyright © 2019 John Pillar. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSlider

class GardenSensorsTableViewCell: UITableViewCell {
   
    @IBOutlet weak var sensorLabel: UILabel!
    @IBOutlet weak var moistureLabel: UILabel!
    @IBOutlet weak var moistureImage: UIImageView!
    @IBOutlet weak var fertiliserLabel: UILabel!
    @IBOutlet weak var fertiliserImage: UIImageView!
    
    func configureWithItem(item: SensorsData) {
        sensorLabel.text = item.plantName
        
        if item.moisture ?? 0 < item.thresholdMoisture ?? 0 {
            moistureImage.image = #imageLiteral(resourceName: "ic_water_red")
        } else {
            moistureImage.image = #imageLiteral(resourceName: "ic_water")
        }
        moistureLabel.text = "\(item.moisture ?? 0)" + " %"

        
        if item.fertiliser ?? 0 < item.thresholdFertilizer ?? 0 {
            fertiliserImage.image = #imageLiteral(resourceName: "ic_fertaliser_red")
        } else {
            fertiliserImage.image = #imageLiteral(resourceName: "ic_fertaliser")
        }
        fertiliserLabel.text = "\(item.fertiliser ?? 0)" + " µS/cm"

    }
}
