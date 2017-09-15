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

    var movieView: UIView!
    var mediaPlayer = VLCMediaPlayer()
    var videoTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Setup event timers to see what the player is doing
        videoTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(mediaPlayerStateChanged), userInfo: nil, repeats: true)

        // Add tap gesture for play/pause
        let gesture = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.movieViewTapped(_:)))
        self.view.addGestureRecognizer(gesture)

        // Play RTSP stream
        let camURL = readPlist(item: "CamURL")
        let url = URL(string: camURL)
        
        let media = VLCMedia(url: url)
        mediaPlayer.media = media
        mediaPlayer.delegate = self
        mediaPlayer.drawable = self.view

        // Show busy acivity
        //SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        //SVProgressHUD.show(withStatus: "Connecting")

        // Play video
        mediaPlayer.play()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Stop spinner
        //SVProgressHUD.dismiss()
        
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
    
    // Allow landscape orientation
    func canRotate() -> Void {}
    
    @objc func mediaPlayerStateChanged(aNotification: NSNotification!)
    {
        
        switch mediaPlayer.state {
        case .error:
            print ("error")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.showError(withStatus: "Network/API connection error")
        case .buffering:
            break
        case .playing:
            SVProgressHUD.dismiss()
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
            UItxt = "Playing"
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
