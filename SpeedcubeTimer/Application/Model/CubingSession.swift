//
//  CubingSession.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 11/04/2022.
//

import Foundation
import SwiftUI

// MARK: - CubingSession

struct CubingSession: Equatable {
    var results: [Result]
    var cube: Cube
    var index: Int
    var id: UUID = UUID()
    
    var bestResult: Result? {
        results.best
    }
}

// MARK: - Additions

extension CubingSession {
    init() {
        results = []
        cube = .three
        index = 1
    }
    
    func avgOfLast(_ count: Int) -> AverageResult? {
        guard results.count >= count else { return nil }
        
        return .init(mode: .avgOf, solves: Array(results.prefix(count)))
    }
    
    func meanOfLast(_ count: Int) -> AverageResult? {
        guard results.count >= count else { return nil }
        
        return .init(mode: .avgOf, solves: Array(results.prefix(count)))
    }
    
    static var initialSession: CubingSession {
        .init(results: [], cube: .three, index: 1)
    }
}
