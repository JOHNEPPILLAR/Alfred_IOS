//
//  Helper.swift
//  Alfred
//
//  Created by John Pillar on 30/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - NetworkError
enum NetworkError: Error {
  case badURL
  case requestFailed
  case jsonConversionFailure
  case invalidData
  case responseUnsuccessful
  case jsonParsingFailure
  case other(Error)

  var localizedDescription: String {
    switch self {
    case .badURL: return "Bad URL"
    case .requestFailed: return "Request Failed"
    case .invalidData: return "Invalid Data"
    case .responseUnsuccessful: return "Response Unsuccessful"
    case .jsonParsingFailure: return "JSON Parsing Failure"
    case .jsonConversionFailure: return "JSON Conversion Failure"
    case .other: return "Unknown Failure"
    }
  }

  static func map(_ error: Error) -> NetworkError {
    return (error as? NetworkError) ?? .other(error)
  }
}

// MARK: - readPlist
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

// MARK: - setAlfredRequestHeaders
func setAlfredRequestHeaders(url: String, httpMethod: String, body: Data? = nil) throws -> (URLRequest?) {
  #if DEBUG
  let baseURL = readPlist(item: "BaseURL")
  // let baseURL = readPlist(item: "BaseURL_Local")
  #else
  let baseURL = readPlist(item: "BaseURL")
  #endif

  guard let apiURL = URL(string: baseURL + "/" + url) else {
      print("Invalid URL: \(baseURL + "/" + url)")
      throw NetworkError.badURL
  }

  let jsonHeader = "application/json"
  let accessKey = readPlist(item: "AccessKey")

  var request = URLRequest(url: apiURL)
  request.httpMethod = httpMethod
  if let putBody = body {
    request.httpBody = putBody
    request.setValue("\(putBody.count)", forHTTPHeaderField: "Content-Length")
  }
  request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
  request.addValue(jsonHeader, forHTTPHeaderField: "Content-Type")
  request.addValue(jsonHeader, forHTTPHeaderField: "Accept")
  request.addValue(accessKey, forHTTPHeaderField: "client-access-key")

  return request
}

// MARK: - getAlfredData
// swiftlint:disable line_length
func callAlfredService(from url: String, httpMethod: String, body: Data? = nil, completion: @escaping (Result<Data, NetworkError>) -> Void) {
  do {
    guard let request = try setAlfredRequestHeaders(
      url: url,
      httpMethod: httpMethod,
      body: body)
    else {
      completion(.failure(.responseUnsuccessful))
      return
    }

    URLSession.shared.dataTask(with: request) { (data, response, error) in
      DispatchQueue.main.async {
        if let error = error {
          print("☣️ Network error: \(error)")
          completion(.failure(.requestFailed))
          return
        }

        guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
          DispatchQueue.main.async {
            print("☣️ Error with the response, unexpected status code: \(String(describing: response))")
            completion(.failure(.responseUnsuccessful))
          }
          return
        }
        if let data = data {
          DispatchQueue.main.async {
            completion(.success(data))
          }
        }
      }
    }.resume()
  } catch {
    DispatchQueue.main.async {
      print("☣️", error.localizedDescription)
      completion(.failure(.requestFailed))
    }
  }
}

// MARK: - getVideoURL
func getVideoURL(url: String) throws -> (URL?) {
  #if DEBUG
  let baseURL = readPlist(item: "BaseURL")
  // let baseURL = readPlist(item: "BaseURL_Local")
  #else
  let baseURL = readPlist(item: "BaseURL")
  #endif

  let accessKey = readPlist(item: "AccessKey")
  guard let returnURL = URL(string: "\(baseURL)/hls/stream/\(url)?clientaccesskey=\(accessKey)") else {
    print("Invalid URL: \(baseURL + "/" + url)")
    throw NetworkError.badURL
  }

  return returnURL
}

// MARK: - UIColor
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
