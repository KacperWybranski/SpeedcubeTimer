//
//  Result.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 19/09/2022.
//

import Foundation

public struct Result: Hashable, Identifiable {
    public var id = UUID()
    var time: TimeInterval
    var scramble: String
    var date: Date
    
    public init(time: TimeInterval, scramble: String, date: Date) {
        self.time = time
        self.scramble = scramble
        self.date = date
    }
    
    public static func == (lhs: Result, rhs: Result) -> Bool {
        (lhs.time == rhs.time &&
            lhs.scramble == rhs.scramble &&
            lhs.id == rhs.id &&
            lhs.date == rhs.date)
    }
}

extension Array where Element == Result {
    public var best: Result? {
        return sorted { $0.time < $1.time }.first
    }
    
    public var worst: Result? {
        return sorted { $0.time < $1.time }.last
    }
    
    public var average: Double? {
        return self.map { $0.time }.average
    }
}
