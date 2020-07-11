//
//  MockData.swift
//  Alfred
//
//  Created by John Pillar on 14/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import Foundation

struct MockSensorDataItem {

    let url = Bundle.main.url(forResource: "mockFlowerCareData", withExtension: "json")!
    lazy var jsonData = try? Data(contentsOf: url)
    let decoder = JSONDecoder()
    lazy var data = try? decoder.decode([SensorDataItem].self, from: jsonData!)
}
