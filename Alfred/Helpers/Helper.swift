//
//  Helper.swift
//  Alfred
//
//  Created by John Pillar on 30/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation
import SwiftUI

enum NetworkError: Error {
    case badURL, badStatusCode, requestFailed, unknown
}

enum HTTPError: LocalizedError {
    case statusCode
    case post
}

func readPlist(item: String) -> String {
    var plistItem: String = ""
    if let path = Bundle.main.path(forResource: "Alfred", ofType: "plist") {
        let dictRoot = NSDictionary(contentsOfFile: path)
        if let dict = dictRoot {
            plistItem = dict[item] as? String ?? ""
        }
    }
    return plistItem
}

func getAlfredData(for url: String) -> (request: URLRequest?, error: NetworkError?) {
    #if DEBUG
    let baseURL = readPlist(item: "BaseURL")
    //let baseURL = readPlist(item: "BaseURL_Local")
    #else
    let baseURL = readPlist(item: "BaseURL")
    #endif

    let accessKey = readPlist(item: "AccessKey")
    guard let url = URL(string: baseURL + "/" + url) else {
        print("Invalid URL")
        return (nil, error: NetworkError.badURL)
    }

    let jsonHeader = "application/json"
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
    request.addValue(jsonHeader, forHTTPHeaderField: "Content-Type")
    request.addValue(jsonHeader, forHTTPHeaderField: "Accept")
    request.addValue(accessKey, forHTTPHeaderField: "client-access-key")

    return (request, error: nil)
}

func putAlfredData(for url: String, body: Data? = nil) -> (request: URLRequest?, error: NetworkError?) {
    #if DEBUG
    let baseURL = readPlist(item: "BaseURL")
    //let baseURL = readPlist(item: "BaseURL_Local")
    #else
    let baseURL = readPlist(item: "BaseURL")
    #endif

    let accessKey = readPlist(item: "AccessKey")
    guard let url = URL(string: baseURL + "/" + url) else {
        print("Invalid URL")
        return (nil, error: NetworkError.badURL)
    }

    let jsonHeader = "application/json"
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    if let putBody = body {
        request.httpBody = putBody
        request.setValue("\(putBody.count)", forHTTPHeaderField: "Content-Length")
    }
    request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
    request.addValue(jsonHeader, forHTTPHeaderField: "Content-Type")
    request.addValue(jsonHeader, forHTTPHeaderField: "Accept")
    request.addValue(accessKey, forHTTPHeaderField: "client-access-key")

    return (request, error: nil)
}

func videoURL(url: String) -> (url: URL?, error: NetworkError?) {
    #if DEBUG
    let baseURL = readPlist(item: "BaseURL")
    //let baseURL = readPlist(item: "BaseURL_Local")
    #else
    let baseURL = readPlist(item: "BaseURL")
    #endif

    let accessKey = readPlist(item: "AccessKey")
    guard let returnURL = URL(string: "\(baseURL)/hls/stream/\(url)?clientaccesskey=\(accessKey)") else {
        print("Invalid video URL")
        return (nil, error: NetworkError.badURL)
    }

    return (returnURL, error: nil)
}

// swiftlint:disable implicit_getter
extension UIColor {
    var color: Color {
        get {
            let rgbColours = self.cgColor.components
            return Color(
                red: Double(rgbColours![0]),
                green: Double(rgbColours![1]),
                blue: Double(rgbColours![2])
            )
        }
    }
}

struct ActivityIndicator: UIViewRepresentable {
    typealias UIView = UIActivityIndicatorView
    var isAnimating: Bool
    var configuration = { (indicator: UIView) in }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView { UIView() }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        configuration(uiView)
    }
}
extension View where Self == ActivityIndicator {
    func configure(_ configuration: @escaping (Self.UIView) -> Void) -> Self {
        Self.init(isAnimating: self.isAnimating, configuration: configuration)
    }
}
