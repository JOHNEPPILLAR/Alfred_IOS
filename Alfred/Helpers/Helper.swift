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

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue(accessKey, forHTTPHeaderField: "client-access-key")

    return (request, error: nil)
}

func putAlfredData(for url: String) -> (request: URLRequest?, error: NetworkError?) {
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

    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue(accessKey, forHTTPHeaderField: "client-access-key")

    return (request, error: nil)
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
