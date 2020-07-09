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
    var active: Bool

    init(id: Int, room: String, active: Bool) {
        self.id = id
        self.room = room
        self.active = active
    }
}

class MenuDataItems: ObservableObject {
    @Published var menuDataItems: [MenuDataItem] = []

    init() {
        self.loadData(roomID: 0)
    }
}

extension MenuDataItems {
    func loadData(roomID: Int = 0) {
        self.menuDataItems = [
            MenuDataItem(id: 0, room: "Garden", active: roomID == 0 ? true : false),
            MenuDataItem(id: 1, room: "Office", active: roomID == 1 ? true : false),
            MenuDataItem(id: 2, room: "Living Room", active: roomID == 2 ? true : false),
            MenuDataItem(id: 3, room: "Bedroom", active: roomID == 3 ? true : false),
            MenuDataItem(id: 4, room: "Kids Bedroom", active: roomID == 4 ? true : false),
            MenuDataItem(id: 5, room: "Kitchen", active: roomID == 5 ? true : false)
        ]
    }
}
