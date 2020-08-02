//
//  FlowerCareDataGraph.swift
//  Alfred
//
//  Created by John Pillar on 11/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct FlowerCareDataGraph: View {

    @EnvironmentObject var stateSettings: StateSettings
    @ObservedObject var flowerCareData: FlowerCareData = FlowerCareData()

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(self.flowerCareData.results) { sensor in
                    GardenSensorChartUIView(sensorData: sensor)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .onAppear {
                self.flowerCareData.loadData(
                    zone: self.stateSettings.flowerCareZone,
                    duration: self.stateSettings.flowerCareduration
                )
            }
        }
    }
}

#if DEBUG
struct FlowerCareDataGraph_Previews: PreviewProvider {

    static func chartData() -> FlowerCareData {
        let flowerCareData: FlowerCareData = FlowerCareData()
        var mockSensorDataItem = MockSensorDataItem()
        flowerCareData.results = mockSensorDataItem.data!
        return flowerCareData
    }

    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            FlowerCareDataGraph(flowerCareData: chartData())
                .environmentObject(StateSettings())
        }
    }
}
#endif
