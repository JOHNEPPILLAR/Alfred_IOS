//
//  HouseSensorsModel.swift
//  Alfred
//
//  Created by John Pillar on 06/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation
import Combine

struct HouseSensorDataItem: Codable {
    let location: String
    let battery: Int
    let temperature: Float
    let humidity: Int
    let pressure: Float?
    let co2: Int?
    let air: Int?
}

public class HouseSensorData: ObservableObject {

    @Published var dataItems = [HouseSensorDataItem]()

    //private var netatmoData: HouseSensorDataItem
    //private var dysonData: HouseSensorDataItem
    private var cancellationToken: AnyCancellable?

    init() {
        loadData()
    }
}

extension HouseSensorData {

    func loadData() {

        let (urlRequest1, errorURL1) = getAlfredData(for: "netatmo/sensors/current")
        let (urlRequest2, errorURL2) = getAlfredData(for: "dyson/sensors/current")

        if errorURL1 != nil && errorURL2 != nil {
            // Netatmo
            let netatmo = URLSession.shared.dataTaskPublisher(for: urlRequest1!)
            .map { $0.data }
            .decode(type: [HouseSensorDataItem].self, decoder: JSONDecoder())

            // Dyson
            let dyson = URLSession.shared.dataTaskPublisher(for: urlRequest2!)
            .map { $0.data }
            .decode(type: [HouseSensorDataItem].self, decoder: JSONDecoder())

            self.cancellationToken = Publishers.Zip(netatmo, dyson)
            .eraseToAnyPublisher()
            .catch { _ in
                Just(([], []))
            }
            .sink(receiveValue: { netatmoDataItems, dysonDataItems in
                print(netatmoDataItems.count)
                print(dysonDataItems.count)
            })

        }

        /*
        getAlfredData(from: "netatmo/sensors/current") { result in
            switch result {
            case .success(let data):
                if let decodedResponse = try? JSONDecoder().decode([HouseSensorDataItem].self, from: data) {
                    self.netatmoData = decodedResponse
                }
            case .failure(let error):
                // Log error
                print(error)
            }
        }
        getAlfredData(from: "dyson/sensors/current") { result in
            switch result {
            case .success(let data):
                if let decodedResponse = try? JSONDecoder().decode([HouseSensorDataItem].self, from: data) {
                    self.dysonData = decodedResponse
                }
            case .failure(let error):
                // Log error
                print(error)
            }
        }
        */

    }
}
