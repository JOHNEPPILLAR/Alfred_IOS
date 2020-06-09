//
//  MenuUIView.swift
//  Alfred
//
//  Created by John Pillar on 31/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct MenuItemCell: View {

    @State private var isActive = false

    let menuDataItem: MenuDataItem

    var body: some View {
        VStack(alignment: .leading) {
            Text(self.menuDataItem.room)
            .fontWeight(isActive ? .bold : .light)
            .foregroundColor(isActive ? .white : .gray)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.horizontal, 5)
            .offset(x: 0, y: isActive ? 31 : 0)
            .onAppear {
                    if self.menuDataItem.active == true {
                        self.isActive.toggle()
                    }
            }
            if isActive {
                Image("yellow_horizontal_line")
                    .offset(x: 5, y: isActive ? -5 : 0)
            }
        }
    }
}

struct MenuUIView: View {

    @ObservedObject var menuData: MenuDataItems = MenuDataItems()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack {
                HStack {
                    ForEach(menuData.menuDataItems) { item in
                        MenuItemCell(menuDataItem: item)
                    }
                }
                Spacer()
            }
        }
    }
}

#if DEBUG
struct MenuUIView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1439366937, green: 0.1623166203, blue: 0.2411367297, alpha: 1))
            .edgesIgnoringSafeArea(.all)
            MenuUIView()
        }
        .previewLayout(
            .fixed(width: 414, height: 80)
        )
    }
}
#endif
