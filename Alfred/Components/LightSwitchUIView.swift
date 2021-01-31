//
//  LightSwitchUIView.swift
//  Alfred
//
//  Created by John Pillar on 13/07/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct LightSwitchUIView: View {

  @EnvironmentObject var stateSettings: StateSettings
  @ObservedObject var lightGroupData: LightGroupData = LightGroupData()

  // @State var value: Double = 0

  var body: some View {
    VStack {
            /*
            CustomSlider(value: $value, range: (0, 100)) { modifiers in
                ZStack {
                    Color.blue.cornerRadius(3).frame(height: 5).modifier(modifiers.barLeft)
                    Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)).cornerRadius(3).frame(height: 5).modifier(modifiers.barRight)
                    ZStack {
                        Circle().fill(Color.yellow)
                        Circle().stroke(Color.white.opacity(0.2), lineWidth: 2)
                        Text(("\(Int(self.value))")).font(.system(size: 11))
                    }
                    //.padding([.top, .bottom], 2)
                    .modifier(modifiers.knob)
                }
                .cornerRadius(15)
            }
            */
      Image(systemName: self.lightGroupData.lightGroupOn ? "lightbulb.fill" : "lightbulb.slash")
        .font(.system(size: 46.0))
        .foregroundColor(self.lightGroupData.lightColor)
        .onAppear {
          self.lightGroupData.loadData(lightGroupID: self.stateSettings.lightGroupID)
        }
        .onDisappear {
          self.lightGroupData.stopTimer()
        }
        .onTapGesture(count: 2) {
          self.lightGroupData.toggleLight()
        }
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    .padding(10)
    .background(Color.black)
    .cornerRadius(10)
    .frame(width: 100, height: 100)
  }
}

#if DEBUG
struct LightSwitchUIView_Previews: PreviewProvider {
  static var previews: some View {
    let stateSettings = StateSettings()
    stateSettings.currentMenuItem = 1

    return ZStack {
      Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
        .edgesIgnoringSafeArea(.all)
      LightSwitchUIView()
        .environmentObject(stateSettings)
    }
  }
}
#endif
