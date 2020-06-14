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
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Group {
                        ForEach(self.flowerCareData.results) { sensor in
                            LineChartUIView(
                                data: self.chartDataMoisture(data: sensor.readings),
                                batteryData: self.chartDataBattery(data: sensor.readings),
                                title: sensor.plantname,
                                threshhold: sensor.thresholdmoisture)
                                .frame(width: geometry.size.width, height: 140)
                                .transition(.opacity)
                                .animation(.easeIn(duration: 1.0)
                            )
                        }
                    }
                }
                Spacer()
            }
            .id(UUID().uuidString)
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
