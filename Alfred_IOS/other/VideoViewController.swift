//
//  VideoViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 17/02/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation;

class VideoViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! AVPlayerViewController
        
        var url = URL(string: readPlist(item: "HarrietCamURL"))
        if segue.identifier == "lottieVideo" {
            url = URL(string: readPlist(item: "LottieCamURL"))
        }
        if let movieURL = url {
            destination.player = AVPlayer(url: movieURL)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
