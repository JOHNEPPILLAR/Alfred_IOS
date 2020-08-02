//
//  ControllerUIView.swift
//  Alfred
//
//  Created by John Pillar on 30/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct ControllerUIView: View {

    @ObservedObject var viewRouter: ViewRouter

    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
            .edgesIgnoringSafeArea(.all)
            VStack {
                if viewRouter.currentPage == "Splash Screen" {
                    SplashUIView(viewRouter: viewRouter)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 2.0)))
                } else if viewRouter.currentPage == "Main" {
                    MainUIView()
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 2.0)))
                } else {
                    EmptyView()
                }
            }
        }
    }
}

#if DEBUG
struct ControllerUIView_Previews: PreviewProvider {
    static var previews: some View {
        ControllerUIView(viewRouter: ViewRouter())
    }
}
#endif
