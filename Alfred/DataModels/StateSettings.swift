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
  @Published var zone: String = "0"
  @Published var plantGraphDuration: String = "day"
  @Published var tpLinkRoom: String = ""
  @Published var camera: String = "garden"
  @Published var currentMenuItem: Int = 0 {
    didSet {
      switch currentMenuItem {
      case 0: // Garden
        zone = "20,21,22,23"
        camera = "garden"
        tpLinkRoom = ""
      case 1: // Office
        zone = "12"
        tpLinkRoom = "office"
      case 2: // Living room
        zone = "8"
        camera = "livingroom"
        tpLinkRoom = "livingroom"
      case 3: // Master bedroom
        zone = "5"
        tpLinkRoom = "master bedroom"
      case 4: // Kids bedroom
        zone = "4"
        camera = "kids"
        tpLinkRoom = "kids"
      case 5: // Kitchen
        zone = "9"
        tpLinkRoom = "kitchen"
      default:
        return
      }
    }
  }
}
