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
            return data[item].moisture
        }
    }

    func chartDataBattery (data: [SensorReadingDataItem]) -> [Double] {
        if data.count == 0 { return [] }
        return (0..<data.count).map { (item) in
            return Double(data[item].battery )
        }
    }

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(self.sensorData.plant)
                        .foregroundColor(.white)
                    Spacer()
                    if self.sensorData.readings.count > 0 {
                        Text("Latest: \(String(format: "%.0f", self.sensorData.readings.last?.moisture ?? 0 ))")
                            .foregroundColor(Int(self.sensorData.readings.last!.moisture) >
                                                Int(self.sensorData.thresholdMoisture) ? .gray : .blue)
                    }
                }
                LineChartUIView(
                    lineData: self.chartDataMoisture(data: self.sensorData.readings ),
                    secondLineData: self.chartDataBattery(data: self.sensorData.readings ),
                    threshhold: Double(self.sensorData.thresholdMoisture)
                )
                .frame(height: 140)
            }
            .padding(10)
            .background(Color.black)
            .cornerRadius(15)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
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
            Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            GardenSensorChartUIView(
                sensorData: chartData()
            )
        }
    }
}
#endif
