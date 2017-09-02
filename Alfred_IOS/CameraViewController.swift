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

    @IBOutlet weak var backgroundImage: UIImageView!
    var movieView: UIView!
    var mediaPlayer = VLCMediaPlayer()
    var videoTimer: Timer!
    
    let ActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Setup camera

        // Add tap gesture for play/pause
        let gesture = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.movieViewTapped(_:)))
        self.view.addGestureRecognizer(gesture)
        
        // Playing RTSP stream
        let camURL = readPlist(item: "CamURL")
        let url = URL(string: camURL)
        
        let media = VLCMedia(url: url)
        mediaPlayer.media = media
        mediaPlayer.delegate = self
        mediaPlayer.drawable = self.view
        
        videoTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(mediaPlayerStateChanged), userInfo: nil, repeats: true)
        
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
            let banner = Banner(title: "An error occured playing the stream", backgroundColor: UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000))
            banner.dismissesOnTap = true
            banner.show(duration: 3.0)
        case .buffering:
            break
        case .playing:
            backgroundImage.image = nil
            ActivityIndicator.stopAnimating();
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
