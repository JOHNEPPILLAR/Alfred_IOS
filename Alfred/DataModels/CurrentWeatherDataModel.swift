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
    var skyConIcon: String?
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
        self.skyConIcon = skyConIcon
        self.summary = summary
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.temperatureHigh = temperatureHigh
        self.temperatureLow = temperatureLow
    }
}

public class CurrentWeatherData: ObservableObject {

    @Published var dataItems = CurrentWeatherDataItem()

    private var results = CurrentWeatherDataItem() {
        didSet {
            switch results.icon {
            case "clear-day": results.skyConIcon = "clearDay"
            case "clear-night": results.skyConIcon = "clearNight"
            case "rain": results.skyConIcon = "rain"
            case "snow": results.skyConIcon = "snow"
            case "sleet": results.skyConIcon = "sleet"
            case "wind": results.skyConIcon = "wind"
            case "fog": results.skyConIcon = "fog"
            case "cloudy": results.skyConIcon = "cloudy"
            case "partly-cloudy-day": results.skyConIcon = "partlyCloudyDay"
            case "partly-cloudy-night": results.skyConIcon = "partlyCloudyNight"
            default: results.skyConIcon = "clearDay"
            }
            self.dataItems = results
        }
    }

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
                print("☣️ error decoding: \(error)")
                return self.emptyPublisher()
            }
            .assign(to: \.results, on: self)
        }
    }
}

        /*
        getAlfredData(from: "weather/today") { result in
            switch result {
            case .success(let data):
                if var decodedResponse = try? JSONDecoder().decode(CurrentWeatherDataItem.self, from: data) {

                    switch decodedResponse.icon {
                    case "clear-day": decodedResponse.skyConIcon = "clearDay"
                    case "clear-night": decodedResponse.skyConIcon = "clearNight"
                    case "rain": decodedResponse.skyConIcon = "rain"
                    case "snow": decodedResponse.skyConIcon = "snow"
                    case "sleet": decodedResponse.skyConIcon = "sleet"
                    case "wind": decodedResponse.skyConIcon = "wind"
                    case "fog": decodedResponse.skyConIcon = "fog"
                    case "cloudy": decodedResponse.skyConIcon = "cloudy"
                    case "partly-cloudy-day": decodedResponse.skyConIcon = "partlyCloudyDay"
                    case "partly-cloudy-night": decodedResponse.skyConIcon = "partlyCloudyNight"
                    default: decodedResponse.skyConIcon = "clearDay"
                    }

                    self.dataItems = [decodedResponse]
                }
            case .failure(let error):
                // Log error
                print(error)
            }
        }
 */
