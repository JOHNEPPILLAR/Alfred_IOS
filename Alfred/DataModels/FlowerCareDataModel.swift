//
//  FlowerCareDataModel.swift
//  Alfred
//
//  Created by John Pillar on 11/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation
import Combine

struct SensorDataItem: Codable, Identifiable, Hashable {
   static func == (lhs: SensorDataItem, rhs: SensorDataItem) -> Bool {
    return (lhs.address, lhs.sensorlabel) < (rhs.address, rhs.sensorlabel)
    }

    var id: Date {
        return Date()
    }
    let plantname: String
    let address: String
    let sensorlabel: String
    let readings: [SensorReadingDataItem]

/*    init(plantname: String? = nil,
         address: String? = nil,
         sensorlabel: String? = nil,
         readings: [SensorReadingDataItem] = []) {
        self.plantname = plantname
        self.address = address
        self.sensorlabel = sensorlabel
        self.readings = readings
    }*/

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct SensorReadingDataItem: Codable, Identifiable {
    let timeofday: String
    var date: Date {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: timeofday) ?? Date()
    }
    let sunlight: Double
    let plantname: String
    let moisture: Double
    let fertiliser: Double
    let battery: Int
    var id: Date {
        return date
    }

/*    init(timeofday: Date? = nil,
         sunlight: Double? = nil,
         plantname: String? = nil,
         moisture: Double? = nil,
         fertiliser: Double? = nil,
         battery: Int? = nil) {
        self.timeofday = timeofday
        self.sunlight = sunlight
        self.plantname = plantname
        self.moisture = moisture
        self.fertiliser = fertiliser
        self.battery = battery
    }*/
 }

public class FlowerCareData: ObservableObject {

    @Published var results = [SensorDataItem]()
    @Published var mockResults: [SensorReadingDataItem] = [
    SensorReadingDataItem(
        timeofday: "2020-05-11T20:00:00.000Z",
        sunlight: 156.33333333333334,
        plantname: "Lemon Tree",
        moisture: 12.80952380952381,
        fertiliser: 175.38095238095238,
        battery: 96),
    SensorReadingDataItem(
        timeofday: "2020-05-11T23:00:00.000Z",
        sunlight: 166.11428571428573,
        plantname: "Lemon Tree",
        moisture: 12.17142857142857,
        fertiliser: 170.25714285714287,
        battery: 95),
    SensorReadingDataItem(
        timeofday: "2020-05-12T02:00:00.000Z",
        sunlight: 251.7941176470588,
        plantname: "Lemon Tree",
        moisture: 11.588235294117647,
        fertiliser: 165.23529411764707,
        battery: 94)
    ]

    private(set) var cancellationToken: AnyCancellable?

    init() {
        loadData(zone: "1-2", durationSpan: "month")
    }
}

extension FlowerCareData {

    func emptyPublisher(completeImmediately: Bool = true) -> AnyPublisher<[SensorDataItem], Never> {
        Empty<[SensorDataItem], Never>(completeImmediately: completeImmediately).eraseToAnyPublisher()
    }

    func loadData(zone: String, durationSpan: String) {

        let (urlRequest, errorURL) = getAlfredData(
            for: "gardenflower/sensors/zone/\(zone)?durationSpan=\(durationSpan)"
        )
        if errorURL == nil {
            self.cancellationToken = URLSession.shared.dataTaskPublisher(for: urlRequest!)
            .map { $0.data }
            .decode(type: [SensorDataItem].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .catch { error -> AnyPublisher<[SensorDataItem], Never> in
                print("☣️ FlowerCareData - error decoding: \(error)")
                return self.emptyPublisher()
            }
            .assign(to: \.results, on: self)
        }
    }
}
