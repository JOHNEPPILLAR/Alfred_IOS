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
    @IBOutlet weak var concentrateView: UIView!
    @IBOutlet weak var readView: UIView!
    @IBOutlet weak var relaxView: UIView!
    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var nightLightView: UIView!

    @IBAction func energiseTap(_ sender: UITapGestureRecognizer) {
        energiseView.backgroundColor = HueColorHelper.getColorFromScene(1)
        concentrateView.backgroundColor = .clear
        readView.backgroundColor = .clear
        relaxView.backgroundColor = .clear
        dimmedView.backgroundColor = .clear
        nightLightView.backgroundColor = .clear
        self.delegate?.updateSceneID(sceneID: 1)
    }
    
    @IBAction func concentrateTap(_ sender: UITapGestureRecognizer) {
        energiseView.backgroundColor = .clear
        concentrateView.backgroundColor = HueColorHelper.getColorFromScene(2)
        readView.backgroundColor = .clear
        relaxView.backgroundColor = .clear
        dimmedView.backgroundColor = .clear
        nightLightView.backgroundColor = .clear
        self.delegate?.updateSceneID(sceneID: 2)
    }
    @IBAction func readTap(_ sender: UITapGestureRecognizer) {
        energiseView.backgroundColor = .clear
        concentrateView.backgroundColor = .clear
        readView.backgroundColor = HueColorHelper.getColorFromScene(3)
        relaxView.backgroundColor = .clear
        dimmedView.backgroundColor = .clear
        nightLightView.backgroundColor = .clear
        self.delegate?.updateSceneID(sceneID: 3)
    }
    @IBAction func relaxTap(_ sender: UITapGestureRecognizer) {
        energiseView.backgroundColor = .clear
        concentrateView.backgroundColor = .clear
        readView.backgroundColor = .clear
        relaxView.backgroundColor = HueColorHelper.getColorFromScene(4)
        dimmedView.backgroundColor = .clear
        nightLightView.backgroundColor = .clear
        self.delegate?.updateSceneID(sceneID: 4)
    }
    @IBAction func dimmedTap(_ sender: UITapGestureRecognizer) {
        energiseView.backgroundColor = .clear
        concentrateView.backgroundColor = .clear
        readView.backgroundColor = .clear
        relaxView.backgroundColor = .clear
        dimmedView.backgroundColor = HueColorHelper.getColorFromScene(5)
        nightLightView.backgroundColor = .clear
        self.delegate?.updateSceneID(sceneID: 5)
    }
    @IBAction func nightLightTap(_ sender: UITapGestureRecognizer) {
        energiseView.backgroundColor = .clear
        concentrateView.backgroundColor = .clear
        readView.backgroundColor = .clear
        relaxView.backgroundColor = .clear
        dimmedView.backgroundColor = .clear
        nightLightView.backgroundColor = HueColorHelper.getColorFromScene(5)
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
        case 6:
            nightLightTap(tapRec)
        default:
            break
        }
    }

}
