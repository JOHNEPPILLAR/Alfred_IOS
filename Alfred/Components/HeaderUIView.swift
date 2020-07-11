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
        GeometryReader { geometry in
            VStack {
                SummaryUIView()
                .frame(width: geometry.size.width, height: 100)
                MenuUIView()
                .frame(width: geometry.size.width, height: 60)
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
            HeaderUIView().environmentObject(StateSettings())
        }
        .previewLayout(
            .fixed(width: 414, height: 170)
        )
    }
}
#endif
