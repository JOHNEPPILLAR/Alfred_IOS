//
//  HeaderUIView.swift
//  Alfred
//
//  Created by John Pillar on 02/06/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct HeaderUIView: View {

    var body: some View {
        VStack {
            SummaryUIView()
            Spacer()
            MenuUIView()
        }.frame(height: 140)
    }
}

#if DEBUG
struct HeaderUIView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            HeaderUIView().environmentObject(StateSettings())
        }
        .previewLayout(
            .fixed(width: 414, height: 160)
        )
    }
}
#endif
