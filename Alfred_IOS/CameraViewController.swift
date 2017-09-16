//
//  CameraViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 15/08/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SVProgressHUD

class CameraViewController: UIViewController, VLCMediaPlayerDelegate {
   
    @IBOutlet weak var videoStateLabel: UILabel!
    
    var videoTimer: Timer!
    var movieView: UIView!
    var mediaPlayer = VLCMediaPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add rotation observer
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        // Setup movieView
        self.movieView = UIView()
        self.movieView.frame = UIScreen.screens[0].bounds
        
        // Add tap gesture for play/pause
        let gesture = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.movieViewTapped(_:)))
        self.movieView.addGestureRecognizer(gesture)
        
        // Add movieView to view controller
        view.addSubview(self.movieView)

        // Set video state label
        videoStateLabel.text = "Connecting..."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Setup event timers to see what the player is doing
        videoTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(mediaPlayerStateChanged), userInfo: nil, repeats: true)

        // Play RTSP stream
        let camURL = readPlist(item: "CamURL")
        let url = URL(string: camURL)
        
        let media = VLCMedia(url: url!)
        mediaPlayer.media = media
        mediaPlayer.delegate = self
        mediaPlayer.drawable = self.movieView
        mediaPlayer.play()
        
        // Bring video state label to front
        view.bringSubview(toFront: videoStateLabel)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Stop video as moving away from view
        mediaPlayer.stop()
        mediaPlayer.media = nil

        // Remove VLC view
        mediaPlayer.drawable = nil

        // Stop timer
        videoTimer.invalidate()

        // Reset screen orientation
        if (self.isMovingFromParentViewController) {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
    }
    
    @objc func rotated() {
        // Always fill entire screen
        self.movieView.frame = self.view.frame
    }
    
    // Allow landscape orientation
    func canRotate() -> Void {}
    
    @objc func mediaPlayerStateChanged(aNotification: NSNotification!)
    {
        
        switch mediaPlayer.state {
        case .error:
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.showError(withStatus: "Network/API connection error")
            break
        case .playing:
            videoStateLabel.text = "Live streaming"
            break
        case .paused:
            videoStateLabel.text = "Paused"
            break
        default: break
        }
    }
    
    @objc func movieViewTapped(_ sender: UITapGestureRecognizer) {
        
        var UItxt = ""

        if mediaPlayer.isPlaying {
            mediaPlayer.pause()
            UItxt = "Paused"
        }
        else {
            mediaPlayer.play()
            UItxt = "Live streaming"
        }
        
        // Inform user of event
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.showInfo(withStatus: UItxt)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
