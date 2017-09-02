//
//  VideoViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 31/08/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoViewController: AVPlayerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let videoURL = readPlist(item: "KidsCamURL")
        let url = URL(string: videoURL)

        let player = AVPlayer(url: url!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
