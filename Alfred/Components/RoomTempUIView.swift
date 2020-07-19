//
//  RoomTempUIView.swift
//  Alfred
//
//  Created by John Pillar on 12/07/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI
import Combine

struct RoomTempUIView: View {

    @EnvironmentObject var stateSettings: StateSettings
    @ObservedObject var houseSensorData: HouseSensorData = HouseSensorData()

    var body: some View {
        VStack {
            Text("\(self.houseSensorData.roomTemp)" + "° C")
                .font(.system(size: 26))
                .fixedSize(horizontal: true, vertical: false)
                .foregroundColor(.white)
                .onAppear {
                    self.houseSensorData.loadData(menuItem: self.stateSettings.currentMenuItem)
                }
            Image(self.houseSensorData.roomHealthIndicator)
                .resizable()
                .frame(width: 30, height: 30)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .padding(10)
        .background(Color.black)
        .cornerRadius(10)
        .frame(width: 100, height: 100)
    }
}

#if DEBUG
struct RoomTempUIView_Previews: PreviewProvider {

    static func roomData() -> HouseSensorData {
        let houseSensorData: HouseSensorData = HouseSensorData()
        houseSensorData.roomHealthIndicator = "air_quality_green"
        houseSensorData.roomTemp = 10
        return houseSensorData
    }

    static var previews: some View {
        let stateSettings = StateSettings()
        stateSettings.currentMenuItem = 1

        return ZStack {
            Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            RoomTempUIView(houseSensorData: roomData())
                .environmentObject(stateSettings)
        }
    }
}
#endif
