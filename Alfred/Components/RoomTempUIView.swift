//
//  RoomTempUIView.swift
//  Alfred
//
//  Created by John Pillar on 12/07/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI

struct RoomTempUIView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#if DEBUG
struct RoomTempUIView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.04249928892, green: 0.1230544075, blue: 0.1653896868, alpha: 1))
            .edgesIgnoringSafeArea(.all)
            RoomTempUIView()
        }
    }
}
#endif
