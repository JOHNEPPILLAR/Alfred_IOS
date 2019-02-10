//
//  Helpers.swift
//  Alfred_IOS
//
//  Created by John Pillar on 23/07/2017.
//  Copyright © 2017 John Pillar. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Int {
    var stringValue:String {
        return "\(self)"
    }
}

func putAPIHeaderData(url: String, body: Data) -> URLRequest {
    #if DEBUG
    let AlfredBaseURL = readPlist(item: "AlfredBaseURL-Local")
    //let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
    #else
    let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
    #endif
    let AlfredAppKey = readPlist(item: "AlfredAppKey")
    let url = URL(string: AlfredBaseURL + url)!
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue(AlfredAppKey, forHTTPHeaderField: "client-access-key")
    request.httpBody = body
    return request
}

func getAPIHeaderData(url: String) -> URLRequest {
    #if DEBUG
    let AlfredBaseURL = readPlist(item: "AlfredBaseURL-Local")
    //let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
    #else
    let AlfredBaseURL = readPlist(item: "AlfredBaseURL")
    #endif
    let AlfredAppKey = readPlist(item: "AlfredAppKey")
    let url = URL(string: AlfredBaseURL + url)!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue(AlfredAppKey, forHTTPHeaderField: "client-access-key")
    return request
}

func getHLSAPIHeaderData(url: String) -> URLRequest {
    let HLSBaseURL = readPlist(item: "HLSBaseURL")
    let AlfredAppKey = readPlist(item: "AlfredAppKey")
    let url = URL(string: HLSBaseURL + url + "?clientaccesskey=" + AlfredAppKey)!
    var request = URLRequest(url: url)
    request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(AlfredAppKey, forHTTPHeaderField: "client-access-key")
    return request
}

func checkAPIData(apiData: Data?, response: URLResponse?, error: Error?) -> Bool {
    if apiData == nil || error != nil { // Check for fundamental networking error
        return false
    }
    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
        return false
    }
    return true
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

extension UIColor {
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
    var isDarkColor: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum < 0.60 ? true : false
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

@IBDesignable class RoundCornersView: UIView {
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
        layer.cornerRadius = 12
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

