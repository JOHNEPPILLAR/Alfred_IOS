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
                            VStack(alignment: .leading) {
                                // swiftlint:disable multiple_closures_with_trailing_closure
                                Button(action: {
                                    if self.stateSettings.currentMenuItem != item.id {
                                        self.stateSettings.currentMenuItem = item.id
                                        self.menuItems.loadData(roomID: self.stateSettings.currentMenuItem)
                                    }
                                }) {
                                    VStack(alignment: .trailing) {
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
                    Spacer()
                }
            }
            //.onAppear {
            //    self.menuItems.loadData(roomID: self.stateSettings.currentMenuItem)
            //}
            .frame(width: geometry.size.width, height: 50)
        }
    }
}

#if DEBUG
struct MenuUIView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1439366937, green: 0.1623166203, blue: 0.2411367297, alpha: 1))
            .edgesIgnoringSafeArea(.all)
            MenuUIView().environmentObject(StateSettings())
        }
        .previewLayout(
            .fixed(width: 414, height: 60)
        )
    }
}
#endif
