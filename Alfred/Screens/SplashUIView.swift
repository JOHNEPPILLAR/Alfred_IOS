//
//  ContentView.swift
//  Alfred
//
//  Created by John Pillar on 20/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI
import Combine

struct SplashUIView: View {

    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var pingData = PingData()
    @State var transitionAppeared: Double = 0

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Image("splash_logo")
            .resizable()
            .accessibility(hidden: true)
            .aspectRatio(contentMode: .fit)
            .frame(width: 60.0, alignment: .center)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if !self.pingData.pingError {
                    self.viewRouter.currentPage = "Main"
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
            Color(#colorLiteral(red: 0.04249928892, green: 0.1230544075, blue: 0.1653896868, alpha: 1))
            .edgesIgnoringSafeArea(.all)
            SplashUIView(viewRouter: ViewRouter())
        }
    }
}
#endif
