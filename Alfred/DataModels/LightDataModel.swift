//
//  LightDataModel.swift
//  Alfred
//
//  Created by John Pillar on 18/07/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation
import Combine
import CoreGraphics
import SwiftUI

// MARK: - LightGroupSaveDataItem
struct LightGroupSaveDataItem: Codable {
    let state: String?

    init(state: String? = nil) {
        self.state = state
    }
}

// MARK: - LightGroupDataItem
struct LightGroupDataItem: Codable {
    let attributes: LightGroupDataItemAttributes?
    let state: StateData?
    let action: Action?

    init(attributes: LightGroupDataItemAttributes? = nil,
         state: StateData? = nil,
         action: Action? = nil) {
        self.attributes = attributes
        self.state = state
        self.action = action
    }
}

// MARK: - Action
struct Action: Codable {
    let attributes: ActionAttributes?
}

// MARK: - ActionAttributes
struct ActionAttributes: Codable {
    let on: Bool?
    let bri: Int?
    let colormode: String?
    let hue, sat: Int?
    let xy: [Double]?
    let ct: Int?
}

// MARK: - LightGroupDataItemAttributes
struct LightGroupDataItemAttributes: Codable {
    let attributes: AttributesAttributes?
}

// MARK: - AttributesAttributes
struct AttributesAttributes: Codable {
    let type: String?
    let lights: [String]?
    let id: Int?
    let name, attributesClass: String?

    enum CodingKeys: String, CodingKey {
        case type, lights, id, name
        case attributesClass
    }
}

// MARK: - State
struct StateData: Codable {
    let attributes: StateAttributes?
}

// MARK: - StateAttributes
struct StateAttributes: Codable {
    let anyOn, allOn: Bool?

    enum CodingKeys: String, CodingKey {
        case anyOn = "any_on"
        case allOn = "all_on"
    }
}

public class LightGroupData: ObservableObject {

    @Published var lightGroupOn: Bool = false
    @Published var brightness: Int = 0
    @Published var lightColor: Color = .gray

    private var timer: Timer?
    private var currentLightGroupID: Int = -1

    var results: LightGroupDataItem = LightGroupDataItem() {
        didSet {
            brightness = results.action?.attributes?.bri ?? 0
            lightGroupOn = results.state?.attributes?.anyOn ?? false
            if lightGroupOn {
                var point: CGPoint = CGPoint()
                point.x = CGFloat(results.action?.attributes?.xy?[0] ?? 0)
                point.y = CGFloat(results.action?.attributes?.xy?[1] ?? 0)
                lightColor = Color(HueColorHelper.colorFromXY(point, forModel: ""))
            } else {
                lightColor = .gray
            }
        }
    }

    private var saved: LightGroupSaveDataItem = LightGroupSaveDataItem() {
        didSet {
            loadData()
            if saved.state == "saved" {
                self.lightGroupOn = !self.lightGroupOn
                if !self.lightGroupOn { self.lightColor = .gray }
            }
        }
    }

    private(set) var cancellationTokenGet: AnyCancellable?
    private(set) var cancellationTokenPut: AnyCancellable?
}

extension LightGroupData {

    func emptyPublisher(completeImmediately: Bool = true) -> AnyPublisher<LightGroupDataItem, Never> {
        Empty<LightGroupDataItem, Never>(completeImmediately: completeImmediately).eraseToAnyPublisher()
    }

    @objc func loadData(lightGroupID: Int = 0) {
        if currentLightGroupID == -1 {
            currentLightGroupID = lightGroupID
        }
        let (urlRequest, errorURL) = getAlfredData(for: "lights/lightgroups/\(currentLightGroupID)")
        if errorURL == nil {
            self.cancellationTokenGet = URLSession.shared.dataTaskPublisher(for: urlRequest!)
            .map { $0.data }
            .decode(type: LightGroupDataItem.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .catch { error -> AnyPublisher<LightGroupDataItem, Never> in
                print("☣️ LightData - error decoding: \(error)")
                return self.emptyPublisher()
            }
            .assign(to: \.results, on: self)
        }

        if timer == nil || !(timer?.isValid ?? false) {
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                self.loadData()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
    }

    func toggleLight() {
        stopTimer()
        let body: [String: Any] = ["power": !lightGroupOn]
        var APIbody: Data?
        do {
            APIbody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch let error as NSError {
            print("Failed to convert json to data type: \(error.localizedDescription)")
        }
        let (urlRequest, errorURL) = putAlfredData(
            for: "lights/lightgroups/\(currentLightGroupID)",
            body: APIbody
        )
        if errorURL == nil {
            self.cancellationTokenPut = URLSession.shared.dataTaskPublisher(for: urlRequest!)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
            }
            .decode(type: LightGroupSaveDataItem.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .replaceError(with: LightGroupSaveDataItem(state: "error"))
            .receive(on: RunLoop.main)
            .assign(to: \.saved, on: self)
        }
    }
}
