//
//  Helpers.swift
//  Alfred_IOS
//
//  Created by John Pillar on 23/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import Foundation
//import UIKit
import SwiftyJSON

func putAPIHeaderData(url: String, body: Data, useScheduler: Bool) -> URLRequest {
    var AlfredBaseURL = readPlist(item: "AlfredBaseURL")
    if (useScheduler) { AlfredBaseURL = readPlist(item: "AlfredSchedulerURL") }
    let AlfredAppKey = readPlist(item: "AlfredAppKey")
    let url = URL(string: AlfredBaseURL + url)!
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue(AlfredAppKey, forHTTPHeaderField: "app_key")
    request.httpBody = body
    return request
}

func getAPIHeaderData(url: String, useScheduler: Bool) -> URLRequest {
    var AlfredBaseURL = readPlist(item: "AlfredBaseURL")
    if (useScheduler) { AlfredBaseURL = readPlist(item: "AlfredSchedulerURL") }
    let AlfredAppKey = readPlist(item: "AlfredAppKey")
    let url = URL(string: AlfredBaseURL + url)!
    var request = URLRequest(url: url)
    request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(AlfredAppKey, forHTTPHeaderField: "app_key")
    return request
}

func checkAPIData(apiData: Data?, response: URLResponse?, error: Error?) -> Bool {

    if apiData == nil || error != nil { // Check for fundamental networking error
        //DispatchQueue.main.async {
            // Show error
            //SVProgressHUD.dismiss() // Dismiss any active HUD
            //SVProgressHUD.showError(withStatus: "Network/API connection error")
        //}
        return false
    }
        
    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
        //DispatchQueue.main.async {
            // Show error
            //SVProgressHUD.dismiss() // Dismiss any active HUD
            //SVProgressHUD.showError(withStatus: "Invalid API request")
        //}
        return false
    }
        
    let json = JSON(data: apiData!)
    let apiStatus = json["sucess"]
    let apiStatusString = apiStatus.string!
    if apiStatusString == "true" {
         return true
    } else {
        //DispatchQueue.main.async {
            // Show error
            //SVProgressHUD.dismiss() // Dismiss any active HUD
            //SVProgressHUD.showError(withStatus: "Invalid API request")
        //}
        return false
    }
}

func readPlist(item: String) -> String {
    
    var plistItem: String = ""
    
    if let path = Bundle.main.path(forResource: "Alfred", ofType: "plist") {
        let dictRoot = NSDictionary(contentsOfFile: path)
        if let dict = dictRoot {
            plistItem = dict[item] as! String
        }
    }
    return plistItem
    
}

@IBDesignable class RoundButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }
}

@IBDesignable class RoundImage: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateRadius()
        }
    }
    
    func updateRadius() {
        layer.masksToBounds = false
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }
}

@IBDesignable class HighlightImage: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.lightGray.cgColor
    }
}

@IBDesignable class Line: UIView {
    override func draw(_ rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(2.0)
        context!.setStrokeColor(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor)
        context?.move(to: CGPoint(x: 0, y: self.frame.size.height))
        context?.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        context!.strokePath()
    }
}
