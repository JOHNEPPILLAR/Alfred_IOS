//
//  LightScene.swift
//  Alfred_IOS
//
//  Created by John Pillar on 18/05/2019.
//  Copyright © 2019 John Pillar. All rights reserved.
//

import UIKit

protocol LightScenesDelegate: class {
    func updateSceneID(sceneID: Int)
}

class LightScenes: UIView {
    
    weak var delegate: LightScenesDelegate?
    
    @IBOutlet weak var energiseView: UIView!
    @IBOutlet weak var energiseText: UILabel!
    @IBOutlet weak var energiseImage: UIImageView!
    @IBOutlet weak var concentrateView: UIView!
    @IBOutlet weak var concentrateText: UILabel!
    @IBOutlet weak var concentrateImage: UIImageView!
    @IBOutlet weak var readView: UIView!
    @IBOutlet weak var readImage: UIImageView!
    @IBOutlet weak var readText: UILabel!
    @IBOutlet weak var relaxView: UIView!
    @IBOutlet weak var relaxText: UILabel!
    @IBOutlet weak var relaxImage: UIImageView!
    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var dimmedText: UILabel!
    @IBOutlet weak var dimmedImage: UIImageView!
    
    @IBAction func energiseTap(_ sender: UITapGestureRecognizer) {
        energiseView.layer.borderWidth = 1
        energiseView.layer.borderColor = UIColor.green.cgColor
        energiseText.textColor = .green
        energiseImage.image = #imageLiteral(resourceName: "ic_energise_green")
        concentrateView.layer.borderWidth = 0
        concentrateText.textColor = .white
        concentrateImage.image = #imageLiteral(resourceName: "ic_concentrate_white")
        readView.layer.borderWidth = 0
        readText.textColor = .white
        readImage.image = #imageLiteral(resourceName: "ic_read_white")
        relaxView.layer.borderWidth = 0
        relaxText.textColor = .white
        relaxImage.image = #imageLiteral(resourceName: "ic_relax_white")
        dimmedView.layer.borderWidth = 0
        dimmedText.textColor = .white
        dimmedImage.image = #imageLiteral(resourceName: "ic_dimmed_white")
        self.delegate?.updateSceneID(sceneID: 1)
    }
    
    @IBAction func concentrateTap(_ sender: UITapGestureRecognizer) {
        energiseView.layer.borderWidth = 0
        energiseText.textColor = .white
        energiseImage.image = #imageLiteral(resourceName: "ic_energise_white")
        concentrateView.layer.borderWidth = 1
        concentrateView.layer.borderColor = UIColor.green.cgColor
        concentrateText.textColor = .green
        concentrateImage.image = #imageLiteral(resourceName: "ic_concentrate_green")
        readView.layer.borderWidth = 0
        readText.textColor = .white
        readImage.image = #imageLiteral(resourceName: "ic_read_white")
        relaxView.layer.borderWidth = 0
        relaxText.textColor = .white
        relaxImage.image = #imageLiteral(resourceName: "ic_relax_white")
        dimmedView.layer.borderWidth = 0
        dimmedText.textColor = .white
        dimmedImage.image = #imageLiteral(resourceName: "ic_dimmed_white")
        self.delegate?.updateSceneID(sceneID: 2)
    }
    @IBAction func readTap(_ sender: UITapGestureRecognizer) {
        energiseView.layer.borderWidth = 0
        energiseText.textColor = .white
        energiseImage.image = #imageLiteral(resourceName: "ic_energise_white")
        concentrateView.layer.borderWidth = 0
        concentrateText.textColor = .white
        concentrateImage.image = #imageLiteral(resourceName: "ic_concentrate_white")
        readView.layer.borderWidth = 1
        readView.layer.borderColor = UIColor.green.cgColor
        readText.textColor = .green
        readImage.image = #imageLiteral(resourceName: "ic_read_green")
        relaxView.layer.borderWidth = 0
        relaxText.textColor = .white
        relaxImage.image = #imageLiteral(resourceName: "ic_relax_white")
        dimmedView.layer.borderWidth = 0
        dimmedText.textColor = .white
        dimmedImage.image = #imageLiteral(resourceName: "ic_dimmed_white")
        self.delegate?.updateSceneID(sceneID: 3)
    }
    @IBAction func relaxTap(_ sender: UITapGestureRecognizer) {
        energiseView.layer.borderWidth = 0
        energiseText.textColor = .white
        energiseImage.image = #imageLiteral(resourceName: "ic_energise_white")
        concentrateView.layer.borderWidth = 0
        concentrateText.textColor = .white
        concentrateImage.image = #imageLiteral(resourceName: "ic_concentrate_white")
        readView.layer.borderWidth = 0
        readText.textColor = .white
        readImage.image = #imageLiteral(resourceName: "ic_read_white")
        relaxView.layer.borderWidth = 1
        relaxView.layer.borderColor = UIColor.green.cgColor
        relaxText.textColor = .green
        relaxImage.image = #imageLiteral(resourceName: "ic_relax_green")
        dimmedView.layer.borderWidth = 0
        dimmedText.textColor = .white
        dimmedImage.image = #imageLiteral(resourceName: "ic_dimmed_white")
        self.delegate?.updateSceneID(sceneID: 4)
    }
    @IBAction func dimmedTap(_ sender: UITapGestureRecognizer) {
        energiseView.layer.borderWidth = 0
        energiseText.textColor = .white
        energiseImage.image = #imageLiteral(resourceName: "ic_energise_white")
        concentrateView.layer.borderWidth = 0
        concentrateText.textColor = .white
        concentrateImage.image = #imageLiteral(resourceName: "ic_concentrate_white")
        readView.layer.borderWidth = 0
        readText.textColor = .white
        readImage.image = #imageLiteral(resourceName: "ic_read_white")
        relaxView.layer.borderWidth = 0
        relaxText.textColor = .white
        relaxImage.image = #imageLiteral(resourceName: "ic_relax_white")
        dimmedView.layer.borderWidth = 1
        dimmedView.layer.borderColor = UIColor.green.cgColor
        dimmedText.textColor = .green
        dimmedImage.image = #imageLiteral(resourceName: "ic_dimmed_green")
        self.delegate?.updateSceneID(sceneID: 5)
    }
    
    func setScene(setSceneID:Int) {
        let tapRec = UITapGestureRecognizer()
        switch setSceneID {
        case 1:
            energiseTap(tapRec)
        case 2:
            concentrateTap(tapRec)
        case 3:
            readTap(tapRec)
        case 4:
            relaxTap(tapRec)
        case 5:
            dimmedTap(tapRec)
        default:
            break
        }
    }

}
