//
//  ViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 08/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class SplashViewController: UIViewController {
    @IBOutlet weak var logoImage: UIImageView!
    
    private let splashController = SplashController()

    // MARK: override functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        UIApplication.shared.applicationIconBadgeNumber = 0 // Clear badges
      
        logoImage.image = UIImage.gif(name: "ic_logo")
      
        splashController.ping() // Make sure Alred is online
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splashController.delegate = self
    }
}

extension SplashViewController: SplashControllerDelegate {
    func didFailDataUpdateWithError() {
        let alert = UIAlertController(title: "Unable to connect to Alfred", message: "Please check your internet connection. Close the app and try again", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
    }

    func didRecieveDataUpdate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.performSegue(withIdentifier: "home", sender: self)
        })
    }
}
