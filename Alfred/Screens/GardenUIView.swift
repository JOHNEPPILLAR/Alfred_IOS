//
//  GardenUIView.swift
//  Alfred
//
//  Created by John Pillar on 31/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct GardenUIView: View {

    @ObservedObject var viewRouter: ViewRouter

    @State var transitionAppeared: Double = 1

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HeaderUIView()
                    .frame(width: geometry.size.width, height: 230)
            }
            Spacer()
        }
    }
}

#if DEBUG
struct GardenUIView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1439366937, green: 0.1623166203, blue: 0.2411367297, alpha: 1))
            .edgesIgnoringSafeArea(.all)
            GardenUIView(viewRouter: ViewRouter())
        }
    }
}
#endif
