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
   
    @IBOutlet weak var playerControls: UIView!
    @IBOutlet weak var pausePlayIcon: UIImageView!
    @IBOutlet weak var volumeIcon: UIImageView!
    
    var videoTimer: Timer!
    var movieView: UIView!
    var mediaPlayer = VLCMediaPlayer()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Buffering")

        // Add rotation observer
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        // Setup movieView
        self.movieView = UIView()
        self.movieView.frame = UIScreen.screens[0].bounds
        
        // Add movieView to view controller
        view.addSubview(self.movieView)
        
        // Setup event timers to see what the player is doing
        videoTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(mediaPlayerStateChanged), userInfo: nil, repeats: true)

        // Setup the media player
        mediaPlayer.delegate = self
        mediaPlayer.drawable = self.movieView

        // Setup the RTSP stream
        let camURL = readPlist(item: "CamURL")
        let url = URL(string: camURL)
        let media = VLCMedia(url: url!)
        mediaPlayer.media = media

        // Play the steeam
        mediaPlayer.play()

        // Bring video control bar to front
        view.bringSubview(toFront: playerControls)
        
        // Add play/pause tap gesture
        //let playPauseTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(playPauseImageTapped))
        //pausePlayIcon.addGestureRecognizer(playPauseTapRecognizer)

        // Add mute tap gesture
        let muteTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(muteImageTapped))
        volumeIcon.addGestureRecognizer(muteTapRecognizer)

    }
    
    /*
     @objc func playPauseImageTapped(gestureRecognizer: UITapGestureRecognizer) {
        if (pausePlayIcon.image == #imageLiteral(resourceName: "ic_play")) {
            mediaPlayer.play()
            pausePlayIcon.image = #imageLiteral(resourceName: "ic_pause")
        } else {
            mediaPlayer.pause()
            pausePlayIcon.image = #imageLiteral(resourceName: "ic_play")
        }
    }
    */

    @objc func muteImageTapped(gestureRecognizer: UITapGestureRecognizer) {
        if (volumeIcon.image == #imageLiteral(resourceName: "ic_mute")) {
            mediaPlayer.currentAudioTrackIndex = -1
            //volumeIcon.isHidden = true
            volumeIcon.image = #imageLiteral(resourceName: "ic_audio")
        } else {
            mediaPlayer.currentAudioTrackIndex = 0
            volumeIcon.image = #imageLiteral(resourceName: "ic_mute")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        SVProgressHUD.dismiss() // Dismiss any active HUD
        
        // Stop video as moving away from view
        //pausePlayIcon.image = #imageLiteral(resourceName: "ic_pause")
        volumeIcon.image = #imageLiteral(resourceName: "ic_mute")
        volumeIcon.isHidden = false
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
        case .buffering:
            SVProgressHUD.dismiss() // Dismiss the loading HUD
        default: break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
