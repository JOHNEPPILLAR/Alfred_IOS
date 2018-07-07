//
//  VideoViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 06/06/2018.
//  Copyright © 2018 John Pillar. All rights reserved.
//

import UIKit
import AVKit
import SVProgressHUD
import AVFoundation;

class VideoViewController: UIViewController {
    
    private let videoController = VideoController()

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var reStartStreamButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add close button action
        closeButton.addTarget(self, action: #selector(closeViewControler), for: .touchUpInside)

        // Add reStart stream button action
        reStartStreamButton.setImage(UIImage(named: "ic_reStart"), for: UIControlState.normal)
        reStartStreamButton.addTarget(self, action: #selector(reStartStreams), for: .touchUpInside)
        reStartStreamButton.imageView?.contentMode = .scaleAspectFit
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
    
    @objc func closeViewControler() {
        self.dismiss(animated: true, completion:nil)
    }

    @objc func reStartStreams() {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to re-start the streams?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.reStartStreamButton.isEnabled = false
            self.videoController.reStartStreams()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

extension VideoViewController: VideoControllerDelegate {
    func didFailDataUpdateWithError() {
        reStartStreamButton.isEnabled = false
        SVProgressHUD.showError(withStatus: "Network/API error")
    }
    
    func reStartDidRecieveDataUpdate() {
        reStartStreamButton.isEnabled = false
        SVProgressHUD.showSuccess(withStatus: "re-starting streams, please wait a minute before retrying")
    }
    
}
