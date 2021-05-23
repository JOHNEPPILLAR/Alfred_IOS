//
//  GardenPlantsDataGraph.swift
//  Alfred
//
//  Created by John Pillar on 22/05/2021.
//  Copyright © 2021 John Pillar. All rights reserved.
//

import SwiftUI

struct GardenPlantsDataGraph: View {

  @EnvironmentObject var stateSettings: StateSettings
  @ObservedObject var gardenPlantsData: PlantsData = PlantsData()

  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack {
        ForEach(self.gardenPlantsData.results) { sensor in
          PlantSensorChartUIView(plantSensorData: sensor)
        }
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      .onAppear {
        self.gardenPlantsData.loadGardenPlantData(
          zone: self.stateSettings.zone,
          duration: self.stateSettings.plantGraphDuration
        )
      }
    }
  }
}

#if DEBUG
struct GardenPlantsDataGraph_Previews: PreviewProvider {

  static func chartData() -> PlantsData {
    let gardenPlantsData: PlantsData = PlantsData()
    var mockHousePlantSensorDataItem = MockPlantSensorDataItem()
    gardenPlantsData.results = mockHousePlantSensorDataItem.data!
    return gardenPlantsData
  }

  static var previews: some View {
    ZStack {
      Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
        .edgesIgnoringSafeArea(.all)
      GardenPlantsDataGraph(gardenPlantsData: chartData())
        .environmentObject(StateSettings())
    }
  }
}
#endif
