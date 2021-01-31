//
//  PingDataModel.swift
//  Alfred
//
//  Created by John Pillar on 30/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation

// MARK: - PingDataItem
struct PingDataItem: Codable {
    let reply: String?
    let error: String?

    init(reply: String? = nil, error: String? = nil) {
        self.reply = reply
        self.error = error
    }
}

// MARK: - PingData class
class PingData: ObservableObject {

    @Published var pingError: Bool = false

    private var results = PingDataItem() {
      didSet {
        if self.results.error != nil {
          pingError = true
        }
      }
    }

    init() {
      loadData()
    }
}

// MARK: - PingData extension
extension PingData {
  func loadData() {
    callAlfredService(from: "health/ping", httpMethod: "GET") { result in
      switch result {
      case .success(let data):
        do {
          let decodedData = try JSONDecoder().decode(PingDataItem.self, from: data)
          self.results = decodedData
        } catch {
          print("JSONSerialization error:", error)
          self.pingError = true
        }
      case .failure(let error):
        print(error.localizedDescription)
        self.pingError = true
      }
    }
  }
}
