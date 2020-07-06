//
//  HeaderUIView.swift
//  Alfred
//
//  Created by John Pillar on 02/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct HeaderUIView: View {

    @State private var showingAlert = false
    @State private var deviceToken: String = ""

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()

                    // swiftlint:disable multiple_closures_with_trailing_closure
                    Button(action: {
                        self.showingAlert = true
                    }) {
                        Image(systemName: "gear")
                        .foregroundColor(.gray)
                        .offset(x: -10)
                    }
                    //.alert(isPresented: self.$showingAlert) {
                    //    Alert(title: Text("Device Token"),
                    //          message: Text(self.deviceToken),
                    //          dismissButton: .default(Text("OK")))
                    //}
                }
                SummaryUIView()
                    .frame(width: geometry.size.width, height: 100)
                MenuUIView()
                    .frame(width: geometry.size.width, height: 80)
            }
        }
    }
}

#if DEBUG
struct HeaderUIView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1439366937, green: 0.1623166203, blue: 0.2411367297, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            HeaderUIView()
        }
        .previewLayout(
            .fixed(width: 414, height: 220)
        )
    }
}
#endif
