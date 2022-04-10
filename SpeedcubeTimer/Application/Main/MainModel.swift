//
//  MainModel.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 28/03/2022.
//

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

enum Cube: CaseIterable {
    case two
    case three
}

struct Result: Hashable, Identifiable {
    var id = UUID()
    var time: TimeInterval
    var scramble: String
    var date: Date
    
    init(time: TimeInterval, scramble: String, date: Date) {
        self.time = time
        self.scramble = scramble
        self.date = date
    }
    
    static func == (lhs: Result, rhs: Result) -> Bool {
        (lhs.time == rhs.time &&
            lhs.scramble == rhs.scramble &&
            lhs.id == rhs.id &&
            lhs.date == rhs.date)
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

extension Array where Element == Result {
    var best: Result? {
        return sorted { $0.time < $1.time }.first
    }
}
