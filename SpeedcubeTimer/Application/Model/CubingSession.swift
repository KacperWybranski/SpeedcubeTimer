//
//  CubingSession.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 11/04/2022.
//

import Foundation
import SwiftUI

struct CubingSession: Equatable {
    var results: [Result]
    var cube: Cube
    var index: Int
    var id: UUID = UUID()
    
    var bestResult: Result? {
        results.best
    }
}

extension CubingSession {
    init() {
        results = []
        cube = .three
        index = 1
    }
}
