//
//  GardenUIView.swift
//  Alfred
//
//  Created by John Pillar on 31/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct MainUIView: View {

    @EnvironmentObject var stateSettings: StateSettings

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HeaderUIView()
                .frame(width: geometry.size.width, height: 200)
                VStack {
                    if self.stateSettings.currentMenuItem == 0 {
                        FlowerCareDataGraph()
                    } else if self.stateSettings.currentMenuItem == 1 {
                        HStack {
                            Spacer()
                                .frame(width: 10)
                            RoomTempUIView()
                            Spacer()
                                .frame(width: 10)
                            LightSwitchUIView()
                            Spacer()
                                .frame(width: 10)
                        }
                        Spacer()
                        FlowerCareDataGraph()
                    } else {
                        Text("To Do")
                    }
                }
                .offset(x: 0, y: -20)
            }
        }
    }
}

#if DEBUG
struct MainUIView_Previews: PreviewProvider {
    static var previews: some View {

        let stateSettings = StateSettings()
        stateSettings.currentMenuItem = 1

        return ZStack {
            Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
            .edgesIgnoringSafeArea(.all)
            MainUIView()
           .environmentObject(stateSettings)
        }
    }
}
#endif
