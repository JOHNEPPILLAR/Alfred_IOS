//
//  GardenSensorChartUIView.swift
//  Alfred
//
//  Created by John Pillar on 05/07/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct GardenSensorChartUIView: View {

    var sensorData: SensorDataItem

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
            VStack {
                HStack {
                    Text(self.sensorData.plantname)
                        .foregroundColor(.white)
                    Spacer()
                    Text("Latest: \(String(format: "%.0f", self.sensorData.readings.last!.moisture.rounded(.up)))")
                        .foregroundColor(self.sensorData.readings.last!.moisture >
                            self.sensorData.thresholdmoisture ? .gray : .red)
                }
                LineChartUIView(
                    lineData: self.chartDataMoisture(data: self.sensorData.readings),
                    secondLineData: self.chartDataBattery(data: self.sensorData.readings),
                    threshhold: self.sensorData.thresholdmoisture
                )
                    .frame(height: 140)
                    .transition(.opacity)
                    .animation(.easeIn(duration: 1.0))
            }
                .frame(width: geometry.size.width - 20, height: 170)
        }
    }
}

#if DEBUG
struct GardenSensorChartUIView_Previews: PreviewProvider {

    static var arrayItem = 0

    static func chartDataMoisture () -> SensorDataItem {
        var mockSensorDataItem = MockSensorDataItem()
        return mockSensorDataItem.data![arrayItem]
    }

    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1439366937, green: 0.1623166203, blue: 0.2411367297, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            GardenSensorChartUIView(
                sensorData: chartDataMoisture()
            )
        }
    }
}
#endif
