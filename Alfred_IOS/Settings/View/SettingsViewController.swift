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
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "ic-close"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(closeViewControler), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
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
        print("You selected cell #\(indexPath.item)!")
    }

}

extension SettingsViewController: SettingsViewControllerDelegate {
    func settingsDidRecieveDataUpdate(json: JSON) {
        SettingsDataArray = json
    }
}

