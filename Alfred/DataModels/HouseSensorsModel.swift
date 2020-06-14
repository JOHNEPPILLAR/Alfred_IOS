//
//  HouseSensorsModel.swift
//  Alfred
//
//  Created by John Pillar on 06/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation
import Combine

struct HouseSensorDataItem: Codable, Comparable {

    static func < (lhs: HouseSensorDataItem, rhs: HouseSensorDataItem) -> Bool {
      return (lhs.co2 ?? 0, lhs.air ?? 0) < (rhs.co2 ?? 0, rhs.air ?? 0)
    }

    let location: String?
    let battery: Int?
    let temperature: Double?
    let humidity: Int?
    let pressure: Double?
    let co2: Int?
    let air: Int?
    let nitrogen: Int?

    init(location: String? = nil,
         battery: Int? = nil,
         temperature: Double? = nil,
         humidity: Int? = nil,
         pressure: Double? = nil,
         co2: Int? = nil,
         air: Int? = nil,
         nitrogen: Int? = nil) {
        self.location = location
        self.battery = battery
        self.temperature = temperature
        self.humidity = humidity
        self.pressure = pressure
        self.co2 = co2
        self.air = air
        self.nitrogen = nitrogen
    }
}

public class HouseSensorData: ObservableObject {

    @Published var healthIndicator: String = "1pxHeader"
    @Published var netatmoData: [HouseSensorDataItem] = []
    @Published var dysonData: [HouseSensorDataItem] = []

    private var cancellationToken: AnyCancellable?

    init() {
        loadData()
    }
}

extension HouseSensorData {

    func emptyPublisher(completeImmediately: Bool = true) -> AnyPublisher<[HouseSensorDataItem], Never> {
           Empty<[HouseSensorDataItem], Never>(completeImmediately: completeImmediately).eraseToAnyPublisher()
       }

    // function_body_length
    // swiftlint:disable cyclomatic_complexity
    func loadData() {
        let (urlRequest1, errorURL1) = getAlfredData(for: "netatmo/sensors/current")
        let (urlRequest2, errorURL2) = getAlfredData(for: "dyson/sensors/current")

        if errorURL1 == nil && errorURL2 == nil {
            // Netatmo
            let netatmo = URLSession.shared.dataTaskPublisher(for: urlRequest1!)
            .map { $0.data }
            .decode(type: [HouseSensorDataItem].self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<[HouseSensorDataItem], Never> in
                print("☣️ HouseSensorData (net) - error decoding: \(error)")
                return self.emptyPublisher()
            }

            // Dyson
            let dyson = URLSession.shared.dataTaskPublisher(for: urlRequest2!)
            .map { $0.data }
            .decode(type: [HouseSensorDataItem].self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<[HouseSensorDataItem], Never> in
                print("☣️ HouseSensorData (dys) - error decoding: \(error)")
                return self.emptyPublisher()
            }

            self.cancellationToken = Publishers.Zip(netatmo, dyson)
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .catch { _ in
                Just(([], []))
            }
            .sink(receiveValue: { netatmoDataItems, dysonDataItems in
                self.netatmoData = netatmoDataItems
                self.dysonData = dysonDataItems

                var airQuality: [Int] = [0, 0]

                let airReading = dysonDataItems.max()?.air ?? 0
                /*
                    Air quality for Dyson
                    1-3 = Low
                    4-6 = Moderate
                    7-9 = High
                */
                switch airReading {
                case ..<3: airQuality[0] = 1
                case 4..<7: airQuality[0] = 2
                case 7...: airQuality[0] = 3
                default: airQuality[0] = 0
                }

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

                switch airQuality.max() {
                case 1: self.healthIndicator = "air_quality_green"
                case 2: self.healthIndicator = "air_quality_yellow"
                default: self.healthIndicator = "air_quality_red"
                }
            })
        }
    }
}
