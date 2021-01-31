//
//  HeatingDataModel.swift
//  Alfred
//
//  Created by John Pillar on 24/10/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation

// MARK: - HeatingDataItem
struct HeatingDataItem: Codable {
  let device: String?
  let location: String?
  let temperature: Double?
  let humidity: Double?
  let connectivity: String?
  let mode: String?
  let ecoMode: String?
  let setPoint: Double?
  let hvac: String?

  init(device: String? = nil,
       location: String? = nil,
       temperature: Double? = nil,
       humidity: Double? = nil,
       connectivity: String? = nil,
       mode: String? = nil,
       ecoMode: String? = nil,
       setPoint: Double? = nil,
       hvac: String? = nil) {
    self.device = device
    self.location = location
    self.temperature = temperature
    self.humidity = humidity
    self.connectivity = connectivity
    self.mode = mode
    self.ecoMode = ecoMode
    self.setPoint = setPoint
    self.hvac = hvac
  }
}

// MARK: - HeatingData class
public class HeatingData: ObservableObject {

  @Published var results = HeatingDataItem()

  init() {
    loadData()
  }
}

// MARK: - HeatingData extension
extension HeatingData {
  func loadData() {
    callAlfredService(from: "nest/sensors/current", httpMethod: "GET") { result in
      switch result {
      case .success(let data):
        do {
          let decodedData = try JSONDecoder().decode([HeatingDataItem].self, from: data)
          self.results = decodedData[0]
        } catch {
          print("☣️ JSONSerialization error:", error)
        }
      case .failure(let error):
        print("☣️", error.localizedDescription)
      }
    }
  }
}
