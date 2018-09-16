//
//  SettingsViewController.swift
//  Alfred_IOS
//
//  Created by John Pillar on 12/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingsViewController: UIViewController {
    
    private let settingsController = SettingsController()

    @IBOutlet weak var settingsCollectionView: UICollectionView?
    
    fileprivate var SettingsDataArray:JSON = [] {
        didSet {
            settingsCollectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsCollectionView?.delegate = self
        settingsCollectionView?.dataSource = self
        settingsController.delegate = self
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        // Add close button
        let leftButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.closeViewControler))
        self.navigationItem.leftBarButtonItem = leftButton
        
        settingsController.getData()
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

extension SettingsViewController: UICollectionViewDelegate {
}

extension SettingsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SettingsDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! SettingsCollectionViewCell
        cell.configureWithItem(item: SettingsDataArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.performSegue(withIdentifier: self.SettingsDataArray[indexPath.item]["segue"].string!, sender: self)
        })        
    }
}

extension SettingsViewController: SettingsViewControllerDelegate {
    func settingsDidRecieveDataUpdate(json: JSON) {
        SettingsDataArray = json
    }
}

