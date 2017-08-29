//
//  CameraViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 15/08/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import BRYXBanner

class CameraViewController: UIViewController, VLCMediaPlayerDelegate {

    var movieView: UIView!
    var mediaPlayer = VLCMediaPlayer()
    //var mediaPlayer = VLCMediaPlayer(options: ["VLC_VERBOSE])
    
    let ActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup camera
        
        // Add rotation observer
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        // Setup movieView
        self.movieView = UIView()
        self.movieView.frame = UIScreen.screens[0].bounds
        self.movieView.backgroundColor = nil
        self.movieView.tag = 100
        
        // Add tap gesture to movieView for play/pause
        let gesture = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.movieViewTapped(_:)))
        self.movieView.addGestureRecognizer(gesture)
        
        // Add movieView to view controller
        self.view.addSubview(self.movieView)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        // Playing RTSP from internet
        let camURL = readPlist(item: "CamURL")
        let url = URL(string: camURL)
        
        let media = VLCMedia(url: url)
        mediaPlayer.media = media
        mediaPlayer.delegate = self
        mediaPlayer.drawable = self.movieView

        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(mediaPlayerStateChanged), userInfo: nil, repeats: true)
        
        // Always fill entire screen
        //movieView.frame = UIScreen.screens[0].bounds
        //movieView.frame = self.view.frame
        
        // Play video
        mediaPlayer.play()
        
        // Show busy acivity
        ActivityIndicator.center = view.center;
        ActivityIndicator.startAnimating();
        view.addSubview(ActivityIndicator)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Stop video as moving away from view
        mediaPlayer.stop()
        mediaPlayer.media = nil
        
//        if self.isBeingDismissed || self.isMovingFromParentViewController {
//            mediaPlayer!.stop()
//            let viewWithTag = self.view.viewWithTag(100)
//            viewWithTag?.removeFromSuperview()
//        }
    }
    
    @objc func rotated() {
        
        // Always fill entire screen
        self.movieView.frame = self.view.frame
        
    }
    
    @objc func mediaPlayerStateChanged(aNotification: NSNotification!)
    {
        
        switch mediaPlayer.state {
        case .error:
            let banner = Banner(title: "An error occured playing the stream", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
            banner.dismissesOnTap = true
            banner.show(duration: 3.0)
        case .buffering:
            break
        case .playing:
            self.movieView.backgroundColor = UIColor.black
            ActivityIndicator.stopAnimating();
            break
        default: break
        }
    }
    
    @objc func movieViewTapped(_ sender: UITapGestureRecognizer) {
        
        var UItxt = ""

        if mediaPlayer.isPlaying {
            mediaPlayer.pause()
            UItxt = "Webcam paused"
        }
        else {
            mediaPlayer.play()
            UItxt = "Webcam playing"
        }
        
        // Inform user of event
        let banner = Banner(title: UItxt, backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
