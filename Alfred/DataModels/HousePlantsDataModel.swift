//
//  FlowerCareDataModel.swift
//  Alfred
//
//  Created by John Pillar on 11/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation

// MARK: - SensorReadingDataItem
struct SensorReadingDataItem: Codable {
  var id: String {
    return time
  }
  let time: String
  let battery: Double
  let temperature: Double
  let lux: Double
  let moisture: Double
  let fertility: Double
}

// MARK: - SensorDataItem
struct SensorDataItem: Codable, Identifiable {
  var id: Date {
    return Date()
  }
  let device: String
  let location: String
  let plant: String
  let zone: Int
  let thresholdMoisture: Double
  let readings: [SensorReadingDataItem]
}

// MARK: - HousePlantsData class
public class HousePlantsData: ObservableObject {
  @Published var results: [SensorDataItem] = [SensorDataItem]()
}

// MARK: - HousePlantsData extension
extension HousePlantsData {
  func loadData(zone: String, duration: String) {
    callAlfredService(from: "houseplants/sensors/zone/\(zone)?duration=\(duration)", httpMethod: "GET") { result in
      switch result {
      case .success(let data):
        do {
          let decodedData = try JSONDecoder().decode([SensorDataItem].self, from: data)
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
