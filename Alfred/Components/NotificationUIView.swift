//
//  NotificationUIView.swift
//  Alfred
//
//  Created by John Pillar on 31/01/2021.
//  Copyright © 2021 John Pillar. All rights reserved.
//

import SwiftUI

struct NotificationUIView: View {

  init() {
    UITableView.appearance().backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
  }

  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var notificationData: NotificationData = NotificationData()

  func removeRow(at offsets: IndexSet) {
    for offset in offsets {
      notificationData.markAsRead(id: notificationData.results[offset].id!)
    }
    let tmpCounter = notificationData.results.count - 1
    if tmpCounter == 0 { presentationMode.wrappedValue.dismiss() }
  }

  var body: some View {
    ZStack {
      Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
        .edgesIgnoringSafeArea(.all)
      VStack {
        HStack {
          Spacer()
          Image(systemName: "xmark.circle")
            .foregroundColor(.white)
            .font(.system(size: 26))
            .onTapGesture {
              presentationMode.wrappedValue.dismiss()
          }
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: 30)
        List {
          ForEach(notificationData.results, id: \.id) { notification in
            ZStack {
              RoundedRectangle(cornerRadius: 15, style: .continuous)
                .foregroundColor(Color(.black))
              HStack {
                Text(notification.notification ?? "")
                  .foregroundColor(.white)
                  .padding(10)
                Spacer()
              }
            }
          }
          .onDelete(perform: removeRow)
          .listRowBackground(Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)))
        }
        .frame(height: 750)
      }
    }
  }
}

struct NotificationUIView_Previews: PreviewProvider {
  static var previews: some View {
    return ZStack {
      Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
        .edgesIgnoringSafeArea(.all)
      NotificationUIView()
        .environment(\.colorScheme, .dark)
    }
  }
}
