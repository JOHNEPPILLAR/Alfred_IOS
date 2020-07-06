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
    let thresholdmoisture: Double
    let readings: [SensorReadingDataItem]

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
 }

public class FlowerCareData: ObservableObject {

    @Published var results = [SensorDataItem]()

    private(set) var cancellationToken: AnyCancellable?

    init() {
        loadData(zone: "1-2", durationSpan: "day")
    }
}

extension FlowerCareData {

    func emptyPublisher(completeImmediately: Bool = true) -> AnyPublisher<[SensorDataItem], Never> {
        Empty<[SensorDataItem], Never>(completeImmediately: completeImmediately).eraseToAnyPublisher()
    }

    func loadData(zone: String, durationSpan: String) {

        let (urlRequest, errorURL) = getAlfredData(
            for: "flowercare/sensors/zone/\(zone)?durationSpan=\(durationSpan)"
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