//
//  ContentView.swift
//  Alfred
//
//  Created by John Pillar on 20/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI
import ActivityIndicators

struct SplashUIView: View {

  @EnvironmentObject var stateSettings: StateSettings
  @ObservedObject var pingData = PingData()
  @State private var isLoading: Bool = true

  var body: some View {
    VStack {
      Spacer()
      HStack(alignment: .lastTextBaseline) {
        Image("splash_logo")
          .resizable()
          .accessibility(hidden: true)
          .aspectRatio(contentMode: .fit)
          .frame(width: 100.0, alignment: .center)
          .offset(x: 2, y: +14)
        Text("l")
          .fontWeight(.light)
          .foregroundColor(.white)
          .font(.system(size: 48))
          .offset(x: -8)
        Text("f")
          .fontWeight(.light)
          .foregroundColor(.white)
          .font(.system(size: 48))
          .offset(x: -8)
        Text("r")
          .fontWeight(.light)
          .foregroundColor(.white)
          .font(.system(size: 48))
          .offset(x: -8)
        Text("e")
          .fontWeight(.light)
          .foregroundColor(.white)
          .font(.system(size: 48))
          .offset(x: -8)
        Text("d")
          .fontWeight(.light)
          .foregroundColor(.white)
          .font(.system(size: 48))
          .offset(x: -8)
      }
      Indicator.Pulse(isAnimating: isLoading, color: .green)
      Spacer()
    }
    .onReceive(pingData.$results) { data in
      if data.error == nil && data.reply != nil {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          self.stateSettings.splashScreen = false
        }
      }
    }
    .alert(isPresented: $pingData.pingError, content: {
      return Alert(title: Text("Unable to connect to Alfred"),
        message: Text("App will now close"),
        dismissButton: .default(Text("OK"), action: {
          print("Closing app")
          exit(0)
        })
      )
    })
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
        .edgesIgnoringSafeArea(.all)
      SplashUIView()
    }
  }
}
#endif
