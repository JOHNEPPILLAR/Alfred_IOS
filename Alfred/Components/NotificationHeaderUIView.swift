//
//  NotificationHeaderUIView.swift
//  Alfred
//
//  Created by John Pillar on 30/01/2021.
//  Copyright © 2021 John Pillar. All rights reserved.
//

import SwiftUI

struct NotificationHeaderUIView: View {

  @ObservedObject var notificationData: NotificationData = NotificationData()
  @State private var isPresented = false

  private var buttonFillColor = Color(.systemRed)

  var body: some View {
    VStack {
      if self.notificationData.results.count > 0 {
        // swiftlint:disable multiple_closures_with_trailing_closure
        Button(action: {
          self.isPresented.toggle()
        }) {
          Text("Notifications")
            .frame(width: 100, height: 30)
            .background(buttonFillColor)
            .font(.system(size: 16))
            .fixedSize(horizontal: true, vertical: true)
            .cornerRadius(10)
            .foregroundColor(.white)
            .padding(10)
        }
        .fullScreenCover(isPresented: $isPresented, content: NotificationUIView.init)
      }
    }
    .onAppear {
      self.notificationData.loadData()
    }
  }
}

#if DEBUG
struct NotificationHeaderUIView_Previews: PreviewProvider {
  static var previews: some View {
    return ZStack {
      Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
        .edgesIgnoringSafeArea(.all)
      NotificationHeaderUIView()
    }
  }
}
#endif
