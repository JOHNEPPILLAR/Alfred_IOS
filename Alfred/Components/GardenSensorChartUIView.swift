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
        if data.count == 0 { return [] }
        return (0..<data.count).map { (item) in
            return data[item].moisture.rounded(.down)
        }
    }

    func chartDataBattery (data: [SensorReadingDataItem]) -> [Double] {
        if data.count == 0 { return [] }
        return (0..<data.count).map { (item) in
            return Double(data[item].battery)
        }
    }

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(self.sensorData.plantname)
                    .foregroundColor(.white)
                    Spacer()
                    if self.sensorData.readings.count > 0 {
                        Text("Latest: \(String(format: "%.0f", self.sensorData.readings.last!.moisture.rounded(.up)))")
                            .foregroundColor(self.sensorData.readings.last!.moisture >
                                self.sensorData.thresholdmoisture ? .gray : .red)
                    }
                }
                LineChartUIView(
                    lineData: self.chartDataMoisture(data: self.sensorData.readings),
                    secondLineData: self.chartDataBattery(data: self.sensorData.readings),
                    threshhold: self.sensorData.thresholdmoisture
                )
                .frame(height: 140)
            }
            .padding(10)
            .background(Color(#colorLiteral(red: 0.07641596347, green: 0.1622726619, blue: 0.2177014351, alpha: 1)))
            .cornerRadius(15)
        }
        .padding(15)
    }
}

#if DEBUG
struct GardenSensorChartUIView_Previews: PreviewProvider {

    static var arrayItem = 0

    static func chartData () -> SensorDataItem {
        var mockSensorDataItem = MockSensorDataItem()
        return mockSensorDataItem.data![arrayItem]
    }

    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.04249928892, green: 0.1230544075, blue: 0.1653896868, alpha: 1))
            .edgesIgnoringSafeArea(.all)
            GardenSensorChartUIView(
                sensorData: chartData()
            )
        }
    }
}
#endif
