//
//  CubingSession.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 11/04/2022.
//

import Foundation
import SwiftUI

class CubingSession: ObservableObject, Equatable {
    @Published var results: [Result]
    @Published var cube: Cube
    @Published var sessionindex: Int
    
    var bestResult: Result? {
        results.best
    }
    
    init(results: [Result], cube: Cube, session: Int) {
        self.results = results
        self.cube = cube
        self.sessionindex = session
        
    }
    
    static var initialSession: CubingSession {
        return CubingSession(results: [], cube: .three, session: 1)
    }
    
    static func == (lhs: CubingSession, rhs: CubingSession) -> Bool {
        return (lhs.results == rhs.results &&
                lhs.cube == rhs.cube &&
                lhs.sessionindex == rhs.sessionindex)
    }
}

extension CubingSession {
    func averageOfLast(_ solvesCount: Int) -> TimeInterval? {
        guard results.count >= solvesCount else { return nil }
        
        var times = results
            .prefix(solvesCount)
            .map { $0.time }
            .sorted()
        times.removeLast()
        times.removeFirst()
        
        return times.average
    }
    
    func meanOfLast(_ solvesCount: Int) -> TimeInterval? {
        guard results.count >= solvesCount else { return nil }
        
        return results
            .prefix(solvesCount)
            .map { $0.time }
            .sorted()
            .average
    }
}
