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
                        FlowerCareDataGraph()
                    } else {
                        Text("To Do")
                    }
                }
                .offset(x: 0, y: -30)
            }
    //        Spacer()
        }
    }
}

#if DEBUG
struct MainUIView_Previews: PreviewProvider {
    static var previews: some View {

        let stateSettings = StateSettings()
        stateSettings.currentMenuItem = 1

        return ZStack {
            Color(#colorLiteral(red: 0.04249928892, green: 0.1230544075, blue: 0.1653896868, alpha: 1))
            .edgesIgnoringSafeArea(.all)
            MainUIView()
           .environmentObject(stateSettings)
        }
    }
}
#endif
