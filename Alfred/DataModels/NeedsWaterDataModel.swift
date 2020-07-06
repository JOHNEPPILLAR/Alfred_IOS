//
//  NeedsWaterDataModel.swift
//  Alfred
//
//  Created by John Pillar on 11/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation
import Combine

struct NeedsWaterDataItem: Codable {
    let address: String?
    let sensorlabel: String?
    let plantname: String?
    let moisture: Double?
    let thresholdmoisture: Double?
    let zone: Int?

    init(address: String? = nil,
         sensorlabel: String? = nil,
         plantname: String? = nil,
         moisture: Double? = nil,
         thresholdmoisture: Double? = nil,
         zone: Int? = nil) {
        self.address = address
        self.sensorlabel = sensorlabel
        self.plantname = plantname
        self.moisture = moisture
        self.thresholdmoisture = thresholdmoisture
        self.zone = zone
    }
}

public class NeedsWaterData: ObservableObject {

    @Published var needsWater: String = "1pxHeader"

    var results = [NeedsWaterDataItem]() {
        didSet {
            if results.count > 0 {
                needsWater = "leaf_red"
            } else {
                needsWater = "leaf_green"
            }
        }
    }

    private(set) var cancellationToken: AnyCancellable?

    init() {
        loadData()
    }
}

extension NeedsWaterData {

    func emptyPublisher(completeImmediately: Bool = true) -> AnyPublisher<[NeedsWaterDataItem], Never> {
        Empty<[NeedsWaterDataItem], Never>(completeImmediately: completeImmediately).eraseToAnyPublisher()
    }

    func loadData() {

        let (urlRequest, errorURL) = getAlfredData(for: "flowercare/needswater")
        if errorURL == nil {
            self.cancellationToken = URLSession.shared.dataTaskPublisher(for: urlRequest!)
            .map { $0.data }
            .decode(type: [NeedsWaterDataItem].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .catch { error -> AnyPublisher<[NeedsWaterDataItem], Never> in
                print("☣️ NeedsWaterData - error decoding: \(error)")
                return self.emptyPublisher()
            }
            .assign(to: \.results, on: self)
        }
    }
}
