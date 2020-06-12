//
//  Helper.swift
//  Alfred
//
//  Created by John Pillar on 30/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badURL, badStatusCode, requestFailed, unknown
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
//    let baseURL = readPlist(item: "BaseURL_Local")
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
