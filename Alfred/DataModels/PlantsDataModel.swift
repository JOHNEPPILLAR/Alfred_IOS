//
//  FlowerCareDataModel.swift
//  Alfred
//
//  Created by John Pillar on 11/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation

// MARK: - PlantSensorReadingDataItem
struct PlantSensorReadingDataItem: Codable {
  var id: String {
    return time
  }
  let time: String
  let battery: Double?
  let temperature: Double?
  let lux: Double?
  let moisture: Double?
  let fertility: Double?
}

// MARK: - PlantSensorDataItem
struct PlantSensorDataItem: Codable, Identifiable {
  var id: Date {
    return Date()
  }
  let device: String
  let location: String
  let plant: String
  let zone: Int
  let thresholdMoisture: Double
  let readings: [PlantSensorReadingDataItem]
}

// MARK: - PlantPlantsData class
public class PlantsData: ObservableObject {
  @Published var results: [PlantSensorDataItem] = [PlantSensorDataItem]()
}

// MARK: - PlantsData extension
extension PlantsData {
  func loadHousePlantData(zone: String, duration: String) {
    callAlfredService(from: "houseplants/sensors/zone/\(zone)?duration=\(duration)", httpMethod: "GET") { result in
      switch result {
      case .success(let data):
        do {
          let decodedData = try JSONDecoder().decode([PlantSensorDataItem].self, from: data)
          self.results = decodedData
        } catch {
          print("☣️ JSONSerialization error:", error)
        }
      case .failure(let error):
        print("☣️", error.localizedDescription)
      }
    }
  }

  func loadGardenPlantData(zone: String, duration: String) {

    // Load garden platns that use FlowerCare devices
    loadHousePlantData(zone: zone, duration: duration)

    // Load garden platns that use FlowerPower devices
    callAlfredService(from: "gardenplants/sensors/zone/\(zone)?duration=\(duration)", httpMethod: "GET") { result in
      switch result {
      case .success(let data):
        do {
          let decodedData = try JSONDecoder().decode([PlantSensorDataItem].self, from: data)
          self.results += decodedData
        } catch {
          print("☣️ JSONSerialization error:", error)
        }
      case .failure(let error):
        print("☣️", error.localizedDescription)
      }
    }
  }

}
