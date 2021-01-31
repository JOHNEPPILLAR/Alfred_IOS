//
//  MenuUIView.swift
//  Alfred
//
//  Created by John Pillar on 31/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct MenuUIView: View {

  @EnvironmentObject var stateSettings: StateSettings
  @ObservedObject var menuItems: MenuDataItems = MenuDataItems()

  var body: some View {
    VStack {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(self.menuItems.menuDataItems) { item in
            VStack {
              // swiftlint:disable multiple_closures_with_trailing_closure
              Button(action: {
                if self.stateSettings.currentMenuItem != item.id {
                  self.stateSettings.currentMenuItem = item.id
                  self.menuItems.loadData(roomID: self.stateSettings.currentMenuItem)
                }
              }) {
                Text(item.room)
                  .underline(item.active ? true : false, color: .yellow)
                  .foregroundColor(item.active ? .white : .gray)
                  .fixedSize(horizontal: true, vertical: false)
                  .padding(.horizontal, 5)
              }
            }
          }
        }
      }
    }
    .frame(height: 30)
  }
}

#if DEBUG
struct MenuUIView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
        .edgesIgnoringSafeArea(.all)
      MenuUIView().environmentObject(StateSettings())
    }
    .previewLayout(
      .fixed(width: 414, height: 50)
    )
  }
}
#endif
