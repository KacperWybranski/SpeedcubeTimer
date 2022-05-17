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
    
    func avgOfLast(_ count: Int) -> Double? {
        guard results.count >= count else { return nil }
            
        var times = results
            .prefix(count)
            .map { $0.time }
            .sorted()
        
        times.removeFirst()
        times.removeFirst()
        return times.average
    }
    
    func meanOfLast(_ count: Int) -> Double? {
        guard results.count >= count else { return nil }
        
        return results
            .prefix(count)
            .map { $0.time }
            .sorted()
            .average
    }
    
    static var initialSession: CubingSession {
        return CubingSession(results: [], cube: .three, index: 1)
    }
}
