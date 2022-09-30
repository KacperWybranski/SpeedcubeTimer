//
//  Result.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 19/09/2022.
//

import Foundation

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

extension Array where Element == Result {
    var best: Result? {
        return sorted { $0.time < $1.time }.first
    }
    
    var worst: Result? {
        return sorted { $0.time < $1.time }.last
    }
    
    var average: Double? {
        return self.map { $0.time }.average
    }
}
