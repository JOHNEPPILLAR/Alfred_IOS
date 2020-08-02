//
//  PingDataModel.swift
//  Alfred
//
//  Created by John Pillar on 30/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation
import Combine

struct PingDataItem: Codable {
    let reply: String?
    let error: String?

    init(reply: String? = nil, error: String? = nil) {
        self.reply = reply
        self.error = error
    }
}

class PingData: ObservableObject {

    @Published var pingError: Bool = false

    private var results = PingDataItem() {
        didSet {
            if self.results.error != nil {
                pingError = true
            }
        }
    }

    private(set) var cancellationToken: AnyCancellable?

    init() {
        loadData()
    }
}

extension PingData {

    func emptyPublisher(completeImmediately: Bool = true) -> AnyPublisher<PingDataItem, Never> {
        Empty<PingDataItem, Never>(completeImmediately: completeImmediately).eraseToAnyPublisher()
    }

    func loadData() {
        let (urlRequest, errorURL) = getAlfredData(for: "health/ping")
        if errorURL == nil {
            self.cancellationToken = URLSession.shared.dataTaskPublisher(for: urlRequest!)
            .map { $0.data }
            .decode(type: PingDataItem.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .catch { error -> AnyPublisher<PingDataItem, Never> in
                print("☣️ PingData - error decoding: \(error)")
                return self.emptyPublisher()
            }
            .assign(to: \.results, on: self)
        }
    }
}
