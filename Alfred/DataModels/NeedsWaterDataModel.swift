//
//  NeedsWaterDataModel.swift
//  Alfred
//
//  Created by John Pillar on 11/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation

// MARK: - NeedsWaterDataItem
struct NeedsWaterDataItem: Codable {
  let device: String?
  let location: String?
  let plant: String?
  let zone: Int?

  init(device: String? = nil, location: String? = nil, plant: String? = nil, zone: Int? = nil) {
    self.device = device
    self.location = location
    self.plant = plant
    self.zone = zone
  }
}

// MARK: - NeedsWaterData class
public class NeedsWaterData: ObservableObject {

  @Published var needsWater: String = "1pxHeader"

  var results = [NeedsWaterDataItem]() {
    didSet {
      if results.count > 0 {
        needsWater = "water_plant"
      } else {
        needsWater = "plant_ok"
      }
    }
  }

  init() {
    loadData()
  }
}

// MARK: - NeedsWaterData extension
extension NeedsWaterData {
  func loadData() {
    callAlfredService(from: "houseplants/needswater", httpMethod: "GET") { result in
      switch result {
      case .success(let data):
        do {
          let decodedData = try JSONDecoder().decode([NeedsWaterDataItem].self, from: data)
          self.results = decodedData
        } catch {
          print("☣️ JSONSerialization error:", error)
        }
      case .failure(let error):
        print("☣️", error.localizedDescription)
      }
    }
  }
}
