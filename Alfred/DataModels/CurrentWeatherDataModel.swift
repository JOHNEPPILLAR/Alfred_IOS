//
//  HeaderModel.swift
//  Alfred
//
//  Created by John Pillar on 04/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation

// MARK: - CurrentWeatherDataItem
struct CurrentWeatherDataItem: Codable {
  let icon: String?
  let summary: String?
  let temperature: Int?
  let feelsLike: Int?
  let temperatureHigh: Int?
  let temperatureLow: Int?

  init(icon: String? = nil,
       summary: String? = nil,
       temperature: Int? = nil,
       feelsLike: Int? = nil,
       temperatureHigh: Int? = nil,
       temperatureLow: Int? = nil) {
    self.icon = icon
    self.summary = summary
    self.temperature = temperature
    self.feelsLike = feelsLike
    self.temperatureHigh = temperatureHigh
    self.temperatureLow = temperatureLow
  }
}

// MARK: - CurrentWeatherData class
public class CurrentWeatherData: ObservableObject {
  @Published var results = CurrentWeatherDataItem()
}

// MARK: - CurrentWeatherData extension
extension CurrentWeatherData {
  func loadData() {
    callAlfredService(from: "weather/today", httpMethod: "GET") { result in
      switch result {
      case .success(let data):
        do {
          let decodedData = try JSONDecoder().decode(CurrentWeatherDataItem.self, from: data)
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
