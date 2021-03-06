//
//  FlowerCareDataGraph.swift
//  Alfred
//
//  Created by John Pillar on 11/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct HousePlantsDataGraph: View {

  @EnvironmentObject var stateSettings: StateSettings
  @ObservedObject var housePlantsData: PlantsData = PlantsData()

  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack {
        ForEach(self.housePlantsData.results) { sensor in
          PlantSensorChartUIView(plantSensorData: sensor)
        }
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      .onAppear {
        self.housePlantsData.loadHousePlantData(
          zone: self.stateSettings.zone,
          duration: self.stateSettings.plantGraphDuration
        )
      }
    }
  }
}

#if DEBUG
struct HousePlantsDataGraph_Previews: PreviewProvider {

  static func chartData() -> PlantsData {
    let housePlantsData: PlantsData = PlantsData()
    var mockHousePlantSensorDataItem = MockPlantSensorDataItem()
    housePlantsData.results = mockHousePlantSensorDataItem.data!
    return housePlantsData
  }

  static var previews: some View {
    ZStack {
      Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
        .edgesIgnoringSafeArea(.all)
      HousePlantsDataGraph(housePlantsData: chartData())
        .environmentObject(StateSettings())
    }
  }
}
#endif
