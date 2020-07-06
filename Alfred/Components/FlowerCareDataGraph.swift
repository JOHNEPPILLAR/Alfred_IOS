//
//  FlowerCareDataGraph.swift
//  Alfred
//
//  Created by John Pillar on 11/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct FlowerCareDataGraph: View {

    @ObservedObject var flowerCareData: FlowerCareData = FlowerCareData()

    func chartDataMoisture (data: [SensorReadingDataItem]) -> [Double] {
        return (0..<data.count).map { (item) in
            return data[item].moisture.rounded(.down)
        }
    }

    func chartDataBattery (data: [SensorReadingDataItem]) -> [Double] {
        return (0..<data.count).map { (item) in
            return Double(data[item].battery)
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(self.flowerCareData.results) { sensor in
                    GardenSensorChartUIView(sensorData: sensor)
                        .frame(height: 170)
                }
            }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
}

#if DEBUG
struct FlowerCareDataGraph_Previews: PreviewProvider {

    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1439366937, green: 0.1623166203, blue: 0.2411367297, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            FlowerCareDataGraph()
        }
    }
}
#endif
