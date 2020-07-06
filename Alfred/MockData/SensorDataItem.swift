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

    /*
    let data: [SensorDataItem] = [
        SensorDataItem(
            plantname: "Lemon Tree",
            address: "xx:xx:xx:xx:xx:96",
            sensorlabel: "A",
            thresholdmoisture: 15,
            readings: [
                SensorReadingDataItem(
                    timeofday: "2020-05-14T14:00:00.000Z",
                    sunlight: 35210.86956521739,
                    plantname: "Lemon Tree",
                    moisture: 19.391304347826086,
                    fertiliser: 140.34782608695653,
                    battery: 98),
                SensorReadingDataItem(
                    timeofday: "2020-05-14T14:00:00.000Z",
                    sunlight: 35210.86956521739,
                    plantname: "Lemon Tree",
                    moisture: 19.391304347826086,
                    fertiliser: 140.34782608695653,
                    battery: 98),
                SensorReadingDataItem(
                    timeofday: "2020-05-14T17:00:00.000Z",
                    sunlight: 925.0588235294117,
                    plantname: "Lemon Tree",
                    moisture: 17,
                    fertiliser: 150.3235294117647,
                    battery: 97),
                SensorReadingDataItem(
                    timeofday: "2020-05-14T20:00:00.000Z",
                    sunlight: 156.31428571428572,
                    plantname: "Lemon Tree",
                    moisture: 15.942857142857143,
                    fertiliser: 145.4,
                    battery: 96),
                SensorReadingDataItem(
                    timeofday: "2020-05-14T23:00:00.000Z",
                    sunlight: 156.7941176470588,
                    plantname: "Lemon Tree",
                    moisture: 15.441176470588236,
                    fertiliser: 139.97058823529412,
                    battery: 95),
                SensorReadingDataItem(
                    timeofday: "2020-05-15T02:00:00.000Z",
                    sunlight: 249.14285714285714,
                    plantname: "Lemon Tree",
                    moisture: 15.257142857142858,
                    fertiliser: 134.02857142857144,
                    battery: 95),
                SensorReadingDataItem(
                    timeofday: "2020-05-15T05:00:00.000Z",
                    sunlight: 2668.735294117647,
                    plantname: "Lemon Tree",
                    moisture: 15.676470588235293,
                    fertiliser: 125.08823529411765,
                    battery: 95)
            ]
        ),
        SensorDataItem(
            plantname: "Strawberry",
            address: "xx:xx:xx:xx:xx:a3",
            sensorlabel: "B",
            thresholdmoisture: 15,
            readings: [
                SensorReadingDataItem(
                    timeofday: "2020-05-14T14:00:00.000Z",
                    sunlight: 61375.391304347824,
                    plantname: "Strawberry",
                    moisture: 16.217391304347824,
                    fertiliser: 63.65217391304348,
                    battery: 41),
                SensorReadingDataItem(
                    timeofday: "2020-05-14T17:00:00.000Z",
                    sunlight: 9927.382352941177,
                    plantname: "Strawberry",
                    moisture: 13.470588235294118,
                    fertiliser: 74.61764705882354,
                    battery: 20),
                SensorReadingDataItem(
                    timeofday: "2020-05-14T20:00:00.000Z",
                    sunlight: 243.74285714285713,
                    plantname: "Strawberry",
                    moisture: 11.6,
                    fertiliser: 72.4,
                    battery: 16),
                SensorReadingDataItem(
                    timeofday: "2020-05-14T23:00:00.000Z",
                    sunlight: 219.8,
                    plantname: "Strawberry",
                    moisture: 11.028571428571428,
                    fertiliser: 68.11428571428571,
                    battery: 14),
                SensorReadingDataItem(
                    timeofday: "2020-05-15T02:00:00.000Z",
                    sunlight: 375.48571428571427,
                    plantname: "Strawberry",
                    moisture: 10.314285714285715,
                    fertiliser: 64.51428571428572,
                    battery: 13),
                SensorReadingDataItem(
                    timeofday: "2020-05-15T05:00:00.000Z",
                    sunlight: 4747.942857142857,
                    plantname: "Strawberry",
                    moisture: 10.657142857142857,
                    fertiliser: 59.6,
                    battery: 13)
            ]
        ),
        SensorDataItem(
            plantname: "Hanging Basket",
            address: "xx:xx:xx:xx:xx:ea",
            sensorlabel: "C",
            thresholdmoisture: 20,
            readings: [
                SensorReadingDataItem(
                    timeofday: "2020-05-17T11:00:00.000Z",
                    sunlight: 531.4,
                    plantname: "Hanging Basket",
                    moisture: 0,
                    fertiliser: 0,
                    battery: 100),
                SensorReadingDataItem(
                    timeofday: "2020-05-17T14:00:00.000Z",
                    sunlight: 6844.05,
                    plantname: "Hanging Basket",
                    moisture: 20.85,
                    fertiliser: 399.5,
                    battery: 99),
                SensorReadingDataItem(
                    timeofday: "2020-05-17T17:00:00.000Z",
                    sunlight: 4575,
                    plantname: "Hanging Basket",
                    moisture: 70.45454545454545,
                    fertiliser: 1996.6363636363637,
                    battery: 99),
                SensorReadingDataItem(
                    timeofday: "2020-05-21T14:00:00.000Z",
                    sunlight: 14584.75,
                    plantname: "Hanging Basket",
                    moisture: 50.7,
                    fertiliser: 760.45,
                    battery: 99),
                SensorReadingDataItem(
                    timeofday: "2020-05-21T17:00:00.000Z",
                    sunlight: 3328.75,
                    plantname: "Hanging Basket",
                    moisture: 49.5,
                    fertiliser: 770.0625,
                    battery: 99),
                SensorReadingDataItem(
                    timeofday: "2020-05-21T20:00:00.000Z",
                    sunlight: 114.20689655172414,
                    plantname: "Hanging Basket",
                    moisture: 48.275862068965516,
                    fertiliser: 767.8965517241379,
                    battery: 99)
            ]
        )
    ]
 */

}
