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
        GeometryReader { geometry in
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
                                    VStack(alignment: .trailing) {
                                        Spacer()
                                        Text(item.room)
                                            .fontWeight(item.active ? .bold : .light)
                                            .foregroundColor(item.active ? .white : .gray)
                                            .fixedSize(horizontal: true, vertical: false)
                                            .padding(.horizontal, 5)
                                        Image("yellow_horizontal_line")
                                            .foregroundColor(item.active ? .yellow : .clear)
                                            .frame(height: 10)
                                            .offset(x: -3, y: -12)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: 60)
        }
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
            .fixed(width: 414, height: 60)
        )
    }
}
#endif
