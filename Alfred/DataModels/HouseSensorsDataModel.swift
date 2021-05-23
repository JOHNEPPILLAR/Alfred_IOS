//
//  HouseSensorsDataModel.swift
//  Alfred
//
//  Created by John Pillar on 06/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

// MARK: - HouseSensorDataItem
struct HouseSensorDataItem: Codable, Comparable {

  static func < (lhs: HouseSensorDataItem, rhs: HouseSensorDataItem) -> Bool {
    return (lhs.co2 ?? 0, lhs.airQuality ?? 0) < (rhs.co2 ?? 0, rhs.airQuality ?? 0)
  }

  let location: String?
  let battery: Int?
  let temperature: Double?
  let humidity: Int?
  let pressure: Double?
  let co2: Int?
  let airQuality: Int?
  let nitrogenDioxideDensity: Int?

  init(location: String? = nil,
       battery: Int? = nil,
       temperature: Double? = nil,
       humidity: Int? = nil,
       pressure: Double? = nil,
       co2: Int? = nil,
       airQuality: Int? = nil,
       nitrogenDioxideDensity: Int? = nil) {
    self.location = location
    self.battery = battery
    self.temperature = temperature
    self.humidity = humidity
    self.pressure = pressure
    self.co2 = co2
    self.airQuality = airQuality
    self.nitrogenDioxideDensity = nitrogenDioxideDensity
  }
}

// MARK: - HouseSensorData class
public class HouseSensorData: ObservableObject {

  @Published var healthIndicator: String = "1pxHeader"
  @Published var netatmoData: [HouseSensorDataItem] = []
  @Published var dysonData: [HouseSensorDataItem] = [] {
    didSet {
      // Viewing a room so calc room air quality data
      if currentMenuItem > -1 {
        currentRoomData(currentMenuItem: currentMenuItem)
      }
    }
  }
  @Published var roomHealthIndicator: String = "1pxHeader"
  @Published var roomTemp: Int = 0

  private var cancellationToken: AnyCancellable?
  private var currentMenuItem: Int = -1
}

// MARK: - HouseSensorData extension
extension HouseSensorData {

  func emptyPublisher(completeImmediately: Bool = true) -> AnyPublisher<[HouseSensorDataItem], Never> {
    Empty<[HouseSensorDataItem], Never>(completeImmediately: completeImmediately).eraseToAnyPublisher()
  }

  // swiftlint:disable function_body_length
  // swiftlint:disable cyclomatic_complexity
  func loadData(menuItem: Int) {
    currentMenuItem = menuItem

    do {
      guard let request1 = try setAlfredRequestHeaders(url: "netatmo/sensors/current", httpMethod: "GET") else {
        return
      }
      guard let request2 = try setAlfredRequestHeaders(url: "dyson/sensors/current", httpMethod: "GET") else {
        return
      }

      // Netatmo
      let netatmo = URLSession.shared.dataTaskPublisher(for: request1)
        .receive(on: DispatchQueue.main)
        .tryMap { response -> Data in
          guard
            let httpURLResponse = response.response as? HTTPURLResponse,
              httpURLResponse.statusCode == 200
          else {
            throw NetworkError.responseUnsuccessful
          }
          return response.data
        }
        .map { $0 }
        .decode(type: [HouseSensorDataItem].self, decoder: JSONDecoder())
        .mapError { NetworkError.map($0) }
        .eraseToAnyPublisher()
        .catch { error -> AnyPublisher<[HouseSensorDataItem], Never> in
          print("☣️ HouseSensorData (net) - error: \(error)")
          return self.emptyPublisher()
          .eraseToAnyPublisher()
        }

        // Dyson
        let dyson = URLSession.shared.dataTaskPublisher(for: request2)
        .receive(on: DispatchQueue.main)
        .tryMap { response -> Data in
          guard
            let httpURLResponse = response.response as? HTTPURLResponse,
              httpURLResponse.statusCode == 200
          else {
            throw NetworkError.responseUnsuccessful
          }
          return response.data
        }
        .map { $0 }
        .decode(type: [HouseSensorDataItem].self, decoder: JSONDecoder())
        .mapError { NetworkError.map($0) }
        .eraseToAnyPublisher()
        .catch { error -> AnyPublisher<[HouseSensorDataItem], Never> in
          print("☣️ HouseSensorData (dys) - error: \(error)")
          return self.emptyPublisher()
          .eraseToAnyPublisher()
        }

        self.cancellationToken = Publishers.Zip(netatmo, dyson)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
        // .catch { _ in
        //   Just(([], []))
        // }
        .sink(receiveValue: { netatmoDataItems, dysonDataItems in
          self.netatmoData = netatmoDataItems
          self.dysonData = dysonDataItems

          var airQuality: [Int] = [0, 0]

          // Dyson
          let airReading = dysonDataItems.max()?.airQuality ?? 0
          airQuality[0] = self.dysonAirQuality(airReading: airReading)

          // Netatmo
          let co2Reading = netatmoDataItems.max()?.co2 ?? 0
          /*
            CO2 for Netatmo
            < 1000    = Healthy
            1000-2000 = Moderate
            > 2000    = High
          */
          switch co2Reading {
          case ..<1000: airQuality[1] = 0
          case 1000..<2000: airQuality[1] = 1
          case 2000...: airQuality[1] = 2
          default: airQuality[1] = 3
          }

          // Combined
          switch airQuality.max() {
          case 1: self.healthIndicator = "air_quality_green"
          case 2: self.healthIndicator = "air_quality_yellow"
          default: self.healthIndicator = "air_quality_red"
          }
        })
    } catch {
      print("☣️", error.localizedDescription)
    }
  }

  // swiftlint:disable cyclomatic_complexity
  func currentRoomData(currentMenuItem: Int) {
    switch currentMenuItem {
    case 1, 3:
      var sensor = "Office"
      if currentMenuItem == 3 { sensor = "Bedroom" }
      let officeData = self.dysonData.filter { $0.location == sensor }
      if officeData.count > 0 {
        self.roomTemp = Int(officeData[0].temperature?.rounded(.up) ?? 0)
        let airQuality = dysonAirQuality(airReading: officeData[0].airQuality ?? 0)
        switch airQuality {
        case 1: self.roomHealthIndicator = "air_quality_green"
        case 2: self.roomHealthIndicator = "air_quality_yellow"
        default: self.roomHealthIndicator = "air_quality_red"
        }
      }
    case 2, 4, 5:
      var sensor = "Kitchen"
      if currentMenuItem == 4 { sensor = "Kids room" } else if currentMenuItem == 2 { sensor = "Living room" }
      let netatmoData = self.netatmoData.filter { $0.location == sensor }
      if netatmoData.count > 0 {
        self.roomTemp = Int(netatmoData[0].temperature?.rounded(.up) ?? 0)
        let airQuality = dysonAirQuality(airReading: netatmoData[0].airQuality ?? 0)
        switch airQuality {
        case 1: self.roomHealthIndicator = "air_quality_green"
        case 2: self.roomHealthIndicator = "air_quality_yellow"
        default: self.roomHealthIndicator = "air_quality_red"
        }
      }
    default:
      return
    }
  }

  func dysonAirQuality (airReading: Int) -> Int {
    /*
      Air quality for Dyson
      1-3 = Low
      4-6 = Moderate
      7-9 = High
    */
    switch airReading {
    case ..<3: return 1
    case 4..<7: return 2
    case 7...: return 3
    default: return 0
    }
  }
}
