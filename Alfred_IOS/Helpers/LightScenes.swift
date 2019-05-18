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
    
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var sunRiseView: UIView!
    @IBOutlet weak var dayTimeLabel: UILabel!
    @IBOutlet weak var dayTimeView: UIView!
    @IBOutlet weak var sunSetLabel: UILabel!
    @IBOutlet weak var sunSetView: UIView!
    @IBOutlet weak var eveningLabel: UILabel!
    @IBOutlet weak var eveningView: UIView!
    @IBOutlet weak var nightTimeLabel: UILabel!
    @IBOutlet weak var nightTimeView: UIView!

    @IBAction func sunRiseTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.white
        sunRiseView.backgroundColor = UIColor.darkGray
        dayTimeLabel.textColor = UIColor.black
        dayTimeView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        sunSetLabel.textColor = UIColor.black
        sunSetView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        eveningLabel.textColor = UIColor.black
        eveningView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        nightTimeLabel.textColor = UIColor.black
        nightTimeView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        self.delegate?.updateSceneID(sceneID: 1)
    }
    
    @IBAction func dayTimeSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.black
        sunRiseView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        dayTimeLabel.textColor = UIColor.white
        dayTimeView.backgroundColor = UIColor.darkGray
        sunSetLabel.textColor = UIColor.black
        sunSetView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        eveningLabel.textColor = UIColor.black
        eveningView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        nightTimeLabel.textColor = UIColor.black
        nightTimeView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        self.delegate?.updateSceneID(sceneID: 2)
    }
    @IBAction func sunSetSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.black
        sunRiseView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        dayTimeLabel.textColor = UIColor.black
        dayTimeView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        sunSetLabel.textColor = UIColor.white
        sunSetView.backgroundColor = UIColor.darkGray
        eveningLabel.textColor = UIColor.black
        eveningView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        nightTimeLabel.textColor = UIColor.black
        nightTimeView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        self.delegate?.updateSceneID(sceneID: 3)
    }
    @IBAction func eveningSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.black
        sunRiseView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        dayTimeLabel.textColor = UIColor.black
        dayTimeView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        sunSetLabel.textColor = UIColor.black
        sunSetView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        eveningLabel.textColor = UIColor.white
        eveningView.backgroundColor = UIColor.darkGray
        nightTimeLabel.textColor = UIColor.black
        nightTimeView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        self.delegate?.updateSceneID(sceneID: 4)
    }
    @IBAction func nightTimeSceneTap(_ sender: UITapGestureRecognizer) {
        sunRiseLabel.textColor = UIColor.black
        sunRiseView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        dayTimeLabel.textColor = UIColor.black
        dayTimeView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        sunSetLabel.textColor = UIColor.black
        sunSetView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        eveningLabel.textColor = UIColor.black
        eveningView.backgroundColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1.0)
        nightTimeLabel.textColor = UIColor.white
        nightTimeView.backgroundColor = UIColor.darkGray
        self.delegate?.updateSceneID(sceneID: 5)
    }
    
    func setScene(setSceneID:Int) {
        switch setSceneID {
        case 1:
            sunRiseLabel.textColor = UIColor.white
            sunRiseView.backgroundColor = UIColor.darkGray
        case 2:
            dayTimeLabel.textColor = UIColor.white
            dayTimeView.backgroundColor = UIColor.darkGray
        case 3:
            sunSetLabel.textColor = UIColor.white
            sunSetView.backgroundColor = UIColor.darkGray
        case 4:
            eveningLabel.textColor = UIColor.white
            eveningView.backgroundColor = UIColor.darkGray
        case 5:
            nightTimeLabel.textColor = UIColor.white
            nightTimeView.backgroundColor = UIColor.darkGray
        default:
            break
        }
    }

}
