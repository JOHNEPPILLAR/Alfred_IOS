//
//  FlowerCareDataModel.swift
//  Alfred
//
//  Created by John Pillar on 11/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation
import Combine

struct SensorReadingDataItem: Codable {
    var id: String {
        return time
    }
    let time: String
    let battery: Int
    let temperature: Double
    let lux: Double
    let moisture: Double
    let fertility: Double
}

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

public class FlowerCareData: ObservableObject {

    @Published var results: [SensorDataItem] = [SensorDataItem]()

    private var cancellationToken: AnyCancellable?
}

extension FlowerCareData {

    func emptyPublisher(completeImmediately: Bool = true) -> AnyPublisher<[SensorDataItem], Never> {
        Empty<[SensorDataItem], Never>(completeImmediately: completeImmediately).eraseToAnyPublisher()
    }

    func loadData(zone: String, duration: String) {
        let (urlRequest, errorURL) = getAlfredData(
            for: "flowercare/sensors/zone/\(zone)?duration=\(duration)"
        )
        if errorURL == nil {
            self.cancellationToken = URLSession.shared.dataTaskPublisher(for: urlRequest!)
            //.map { $0.data }
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
            }
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
