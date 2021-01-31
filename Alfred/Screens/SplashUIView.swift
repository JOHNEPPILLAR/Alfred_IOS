//
//  ContentView.swift
//  Alfred
//
//  Created by John Pillar on 20/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct SplashUIView: View {

  @EnvironmentObject var stateSettings: StateSettings
  @ObservedObject var pingData = PingData()

  var body: some View {
    HStack(alignment: .lastTextBaseline) {
      Image("splash_logo")
        .resizable()
        .accessibility(hidden: true)
        .aspectRatio(contentMode: .fit)
        .frame(width: 80.0, alignment: .center)
        .offset(x: 10, y: +12)
      Text("l")
        .fontWeight(.light)
        .foregroundColor(.white)
        .font(.system(size: 48))
      Text("f")
        .fontWeight(.light)
        .foregroundColor(.white)
        .font(.system(size: 48))
      Text("r")
        .fontWeight(.light)
        .foregroundColor(.white)
        .font(.system(size: 48))
      Text("e")
        .fontWeight(.light)
        .foregroundColor(.white)
        .font(.system(size: 48))
      Text("d")
        .fontWeight(.light)
        .foregroundColor(.white)
        .font(.system(size: 48))
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        if !self.pingData.pingError {
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
