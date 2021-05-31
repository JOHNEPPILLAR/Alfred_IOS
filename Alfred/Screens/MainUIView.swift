//
//  GardenUIView.swift
//  Alfred
//
//  Created by John Pillar on 31/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI
import AVKit

struct MainUIView: View {

  @EnvironmentObject var stateSettings: StateSettings

  var body: some View {
    VStack {
      NotificationHeaderUIView()
      HeaderUIView()
      VStack {
        if self.stateSettings.currentMenuItem == 0 { // garden
          VStack {
            // VideoUIView()
            GardenPlantsDataGraph()
            Spacer()
          }
          .transition(AnyTransition.opacity.animation(.easeIn(duration: 0.5)))
        }
        if self.stateSettings.currentMenuItem == 1 { // Office
          VStack {
            HStack {
              Spacer()
                .frame(width: 10)
              RoomTempUIView()
                .transition(.slide)
              Spacer()
                .frame(width: 10)
              LightSwitchUIView()
                .transition(.slide)
              Spacer()
                .frame(width: 10)
            }
            Spacer()
            HousePlantsDataGraph()
          }
          .transition(AnyTransition.opacity.animation(.easeIn(duration: 0.5)))
        }
        if self.stateSettings.currentMenuItem == 2 { // Living rooms
          VStack {
            HStack {
              Spacer()
                .frame(width: 10)
              RoomTempUIView()
                // .transition(.slide)
              Spacer()
                .frame(width: 10)
              LightSwitchUIView()
                // .transition(.slide)
              Spacer()
                .frame(width: 10)
            }
            Spacer()
            // VideoUIView()
            HousePlantsDataGraph()
          }
          .transition(AnyTransition.opacity.animation(.easeIn(duration: 0.5)))
        }
        if self.stateSettings.currentMenuItem == 3 { // Bedroom
          VStack {
            HStack {
              Spacer()
                .frame(width: 10)
              RoomTempUIView()
                .transition(.slide)
              Spacer()
                .frame(width: 10)
              LightSwitchUIView()
                .transition(.slide)
              Spacer()
                .frame(width: 10)
            }
            Spacer()
            HousePlantsDataGraph()
          }
          .transition(AnyTransition.opacity.animation(.easeIn(duration: 0.5)))
        }
        if self.stateSettings.currentMenuItem == 4 { // Kids bedroom
          VStack {
            HStack {
              Spacer()
                .frame(width: 10)
              RoomTempUIView()
                .transition(.slide)
              Spacer()
                .frame(width: 10)
              LightSwitchUIView()
                .transition(.slide)
              Spacer()
                .frame(width: 10)
            }
            VideoUIView()
            Spacer()
            HousePlantsDataGraph()
          }
          .transition(AnyTransition.opacity.animation(.easeIn(duration: 0.5)))
        }
        if self.stateSettings.currentMenuItem == 5 { // Kitchen
          VStack {
            HStack {
              Spacer()
                .frame(width: 10)
              RoomTempUIView()
                .transition(.slide)
              Spacer()
                .frame(width: 10)
              LightSwitchUIView()
                .transition(.slide)
              Spacer()
                .frame(width: 10)
              }
              Spacer()
            }
            .transition(AnyTransition.opacity.animation(.easeIn(duration: 0.5)))
          }
        }
      }
    }
}

#if DEBUG
struct MainUIView_Previews: PreviewProvider {
  static var previews: some View {

  let stateSettings = StateSettings()
  stateSettings.currentMenuItem = 0

  return ZStack {
    Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
      .edgesIgnoringSafeArea(.all)
    MainUIView()
      .environmentObject(stateSettings)
    }
  }
}
#endif
