//
//  ScreenState.swift
//  Alfred
//
//  Created by John Pillar on 07/07/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation

class StateSettings: ObservableObject {
    @Published var flowerCareZone: String = "1-2"
    @Published var flowerCareduration: String = "day"
    @Published var currentMenuItem: Int = 0 {
        didSet {
            switch currentMenuItem {
            case 0:
                flowerCareZone = "1-2"
            case 1:
                flowerCareZone = "3"
            default:
                return
            }
        }
    }
}
