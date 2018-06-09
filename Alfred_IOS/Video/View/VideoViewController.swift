//
//  VideoViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 06/06/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation;


class VideoViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add close button action
        closeButton.setImage(UIImage(named: "ic-close"), for: UIControl.State.normal)
        closeButton.addTarget(self, action: #selector(closeViewControler), for: UIControl.Event.touchUpInside)
        closeButton.imageView?.contentMode = .scaleAspectFit
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "LottieVideo"?:
            let destination = segue.destination as! AVPlayerViewController
            let url = URL(string: readPlist(item: "LottieCamURL"))
            if let movieURL = url {
                destination.player = AVPlayer(url: movieURL)
                destination.player?.play()
            }
        case "HarrietVideo"?:
            let destination = segue.destination as! AVPlayerViewController
            let url = URL(string: readPlist(item: "HarrietCamURL"))
            if let movieURL = url {
                destination.player = AVPlayer(url: movieURL)
                destination.player?.play()
            }
        case .none:
            return
        case .some(_):
            return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func closeViewControler() {
        self.dismiss(animated: true, completion:nil)
    }
}
