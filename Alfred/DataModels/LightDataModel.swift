//
//  LightDataModel.swift
//  Alfred
//
//  Created by John Pillar on 18/07/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation
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
    let hue: Int?
    let sat: Int?
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
    let id: String?
    let name: String?
    let attributesClass: String?

    enum CodingKeys: String, CodingKey {
        case type, lights, id, name
        case attributesClass = "class"
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

// MARK: - LightGroupData class
public class LightGroupData: ObservableObject {

    @Published var lightGroupOn: Bool = false
    @Published var brightness: Int = 0
    @Published var lightColor: Color = .gray

    private var timer: Timer?
    private var currentLightGroupID: Int = -1

    var results: [LightGroupDataItem] = [LightGroupDataItem]() {
        didSet {
            if results.count > 0 {
                brightness = results[0].action?.attributes?.bri ?? 0
                lightGroupOn = results[0].state?.attributes?.anyOn ?? false
                if lightGroupOn {
                    switch results[0].action?.attributes?.colormode {
                    case nil, "ct": // White or yellow only
                        // if val < x then white else yellow
                        lightColor = .white
                    case "xy": // Color
                        var point: CGPoint = CGPoint()
                        point.x = CGFloat(results[0].action?.attributes?.xy?[0] ?? 0)
                        point.y = CGFloat(results[0].action?.attributes?.xy?[1] ?? 0)
                        lightColor = Color(HueColorHelper.colorFromXY(point, forModel: "")) // add light model
                    default: // HS
                        lightColor = .white
                    }
                } else {
                    lightColor = .gray
                }
            }
        }
    }

    private var saved: LightGroupSaveDataItem = LightGroupSaveDataItem() {
        didSet {
            if saved.state == "saved" {
                self.lightGroupOn = !self.lightGroupOn
                if !self.lightGroupOn { self.lightColor = .gray }
            }
        }
    }
}

// MARK: - LightGroupData extension
extension LightGroupData {

    @objc func loadData(lightGroupID: Int = 0) {
        if currentLightGroupID == -1 {
            currentLightGroupID = lightGroupID
        }

        callAlfredService(from: "lights/lightgroups/\(currentLightGroupID)", httpMethod: "GET") { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode([LightGroupDataItem].self, from: data)
                    DispatchQueue.main.async {
                        self.results = decodedData
                    }
                } catch {
                    print("☣️ JSONSerialization error:", error)
                }
            case .failure(let error):
                print("☣️", error.localizedDescription)
            }
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
            self.loadData()
            return
        }
        // swiftlint:disable line_length
        callAlfredService(from: "lights/lightgroups/\(currentLightGroupID)", httpMethod: "PUT", body: APIbody) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(LightGroupSaveDataItem.self, from: data)
                    DispatchQueue.main.async {
                        self.saved = decodedData
                    }
                } catch {
                    print("☣️ JSONSerialization error:", error)
                }
            case .failure(let error):
                print("☣️", error.localizedDescription)
            }
            self.loadData()
        }
    }
}
