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
                .frame(width: geometry.size.width, height: 230)
                if self.stateSettings.currentMenuItem == 0 {
                    FlowerCareDataGraph()
                } else if self.stateSettings.currentMenuItem == 1 {
                    FlowerCareDataGraph()
                } else {
                    Text("To Do")
                }
            }
            Spacer()
        }
    }
}

#if DEBUG
struct MainUIView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1439366937, green: 0.1623166203, blue: 0.2411367297, alpha: 1))
            .edgesIgnoringSafeArea(.all)
            MainUIView()
            .environmentObject(StateSettings())
        }
    }
}
#endif
