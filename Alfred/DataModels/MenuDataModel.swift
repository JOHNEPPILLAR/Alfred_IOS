//
//  MenuDataModel.swift
//  Alfred
//
//  Created by John Pillar on 31/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation

struct MenuDataItem: Identifiable {
    let id: Int
    let room: String
    let active: Bool

    init(id: Int, room: String, active: Bool) {
        self.id = id
        self.room = room
        self.active = active
    }
}

class MenuDataItems: ObservableObject {

    @Published var menuDataItems: [MenuDataItem]

    init() {
        self.menuDataItems = [
            MenuDataItem(id: 0, room: "Garden", active: true),
            MenuDataItem(id: 1, room: "Office", active: false),
            MenuDataItem(id: 2, room: "Living Room", active: false),
            MenuDataItem(id: 3, room: "Bedroom", active: false),
            MenuDataItem(id: 4, room: "Kids Bedroom", active: false),
            MenuDataItem(id: 5, room: "Kitchen", active: false)
        ]
    }

}
