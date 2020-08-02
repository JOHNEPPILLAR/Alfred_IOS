//
//  ViewRouter.swift
//  Alfred
//
//  Created by John Pillar on 30/05/2020.
//  Copyright © 2020 John Pillar. All rights reserved.
//

import SwiftUI
import Combine

class ViewRouter: ObservableObject {

    let objectWillChange = PassthroughSubject<ViewRouter, Never>()

    var currentPage: String = "Splash Screen" {
        didSet {
            withAnimation {
                objectWillChange.send(self)
            }
        }
    }
}
