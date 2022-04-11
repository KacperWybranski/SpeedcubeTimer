//
//  Model.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 11/04/2022.
//

import Foundation

// MARK: - Cube

enum Cube: CaseIterable {
    case two
    case three
}

// MARK: - SelectionType

protocol SelectionType {
    var name: String { get }
}

extension Int: SelectionType {
    var name: String { "\(self)" }
}

extension Cube: SelectionType {
    var name: String {
        switch self {
        case .two: return "2x2"
        case .three: return "3x3"
        }
    }
}

// MARK: - Result

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
}
