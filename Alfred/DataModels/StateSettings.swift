//
//  ScreenState.swift
//  Alfred
//
//  Created by John Pillar on 07/07/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation

// MARK: - StateSettings class
class StateSettings: ObservableObject {
    @Published var splashScreen: Bool = true
    @Published var flowerCareZone: String = "1,2"
    @Published var flowerCareDuration: String = "day"
    @Published var lightGroupID: Int = 0
    @Published var tpLinkRoom: String = ""
    @Published var camera: String = "garden"
    @Published var currentMenuItem: Int = 0 {
        didSet {
            switch currentMenuItem {
            case 0: // Garden
                flowerCareZone = "1,2"
                camera = "garden"
                tpLinkRoom = ""
            case 1: // Office
                flowerCareZone = "3"
                lightGroupID = 12
                tpLinkRoom = "office"
            case 2: // Living room
                flowerCareZone = "5"
                lightGroupID = 8
                camera = "livingroom"
                tpLinkRoom = "livingroom"
            case 3: // Master bedroom
                flowerCareZone = "4"
                lightGroupID = 5
                tpLinkRoom = "master bedroom"
            case 4: // Kids bedroom
                lightGroupID = 4
                camera = "kids"
                tpLinkRoom = "kids"
            case 5: // Kitchen
                lightGroupID = 9
                tpLinkRoom = "kitchen"
            default:
                return
            }
        }
    }
}
