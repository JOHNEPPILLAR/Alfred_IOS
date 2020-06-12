//
//  HeaderModel.swift
//  Alfred
//
//  Created by John Pillar on 04/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation
import Combine

struct CurrentWeatherDataItem: Codable {
    let icon: String?
    let summary: String?
    let temperature: Int?
    let apparentTemperature: Int?
    let temperatureHigh: Int?
    let temperatureLow: Int?

    init(icon: String? = nil,
         skyConIcon: String? = nil,
         summary: String? = nil,
         temperature: Int? = nil,
         apparentTemperature: Int? = nil,
         temperatureHigh: Int? = nil,
         temperatureLow: Int? = nil) {

        self.icon = icon
        self.summary = summary
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.temperatureHigh = temperatureHigh
        self.temperatureLow = temperatureLow
    }
}

public class CurrentWeatherData: ObservableObject {

    @Published var results = CurrentWeatherDataItem()

    private(set) var cancellationToken: AnyCancellable?

    init() {
        loadData()
    }
}

extension CurrentWeatherData {

    func emptyPublisher(completeImmediately: Bool = true) -> AnyPublisher<CurrentWeatherDataItem, Never> {
        Empty<CurrentWeatherDataItem, Never>(completeImmediately: completeImmediately).eraseToAnyPublisher()
    }

    func loadData() {

        let (urlRequest, errorURL) = getAlfredData(for: "weather/today")
        if errorURL == nil {
            self.cancellationToken = URLSession.shared.dataTaskPublisher(for: urlRequest!)
            .map { $0.data }
            .decode(type: CurrentWeatherDataItem.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .catch { error -> AnyPublisher<CurrentWeatherDataItem, Never> in
                print("☣️ CurrentWeatherData - error decoding: \(error)")
                return self.emptyPublisher()
            }
            .assign(to: \.results, on: self)
        }
    }
}
