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
  @State private var showNotificationMsg = false

  init() {
    self.notificationData.loadData()
  }

  var body: some View {
    VStack {
      if showNotificationMsg {
        // swiftlint:disable multiple_closures_with_trailing_closure
        Button(action: {
          self.isPresented.toggle()
        }) {
          Text("Notifications")
            .frame(width: 120, height: 30)
            .background(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
            .font(.system(size: 16))
            .fixedSize(horizontal: true, vertical: true)
            .cornerRadius(10)
            .foregroundColor(.white)
            .padding(10)
        }
        .fullScreenCover(isPresented: $isPresented, content: NotificationUIView.init)
      }
    }
    .onReceive(notificationData.$results) { data in
      if data.count > 0 {
        self.showNotificationMsg = true
      } else {
        self.showNotificationMsg = false
      }
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
