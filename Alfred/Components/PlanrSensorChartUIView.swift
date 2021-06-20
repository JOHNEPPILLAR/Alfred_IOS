//
//  GardenSensorChartUIView.swift
//  Alfred
//
//  Created by John Pillar on 05/07/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct PlantSensorChartUIView: View {

  var plantSensorData: PlantSensorDataItem

  func chartDataMoisture (data: [PlantSensorReadingDataItem]) -> [Double] {
    if data.count == 0 { return [] }
    return (0..<data.count).map { (item) in
      return data[item].moisture ?? 0
    }
  }

  func chartDataBattery (data: [PlantSensorReadingDataItem]) -> [Double] {
    if data.count == 0 { return [] }
    return (0..<data.count).map { (item) in
      return Double(data[item].battery ?? 0)
    }
  }

  var body: some View {
    VStack {
      VStack(alignment: .leading, spacing: -5) {
        HStack {
          Text(self.plantSensorData.plant)
            .foregroundColor(.white)
          Spacer()
          if self.plantSensorData.readings.count > 0 {
            Text("Latest: \(String(format: "%.0f", self.plantSensorData.readings.last?.moisture ?? 0 ))")
              .foregroundColor(Int(self.plantSensorData.readings.last!.moisture ?? 0) >
                                Int(self.plantSensorData.thresholdMoisture) ? .gray : .blue)
          }
        }
        LineChartUIView(
          lineData: self.chartDataMoisture(data: self.plantSensorData.readings ),
          secondLineData: self.chartDataBattery(data: self.plantSensorData.readings ),
          threshhold: Double(self.plantSensorData.thresholdMoisture)
        )
        .frame(height: 90)
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

  static func chartData () -> PlantSensorDataItem {
    var mockPlantSensorDataItem = MockPlantSensorDataItem()
    return mockPlantSensorDataItem.data![arrayItem]
  }

  static var previews: some View {
    ZStack {
      Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
        .edgesIgnoringSafeArea(.all)
      PlantSensorChartUIView(
        plantSensorData: chartData()
      )
    }
  }
}
#endif
