//
//  AverageResult.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 18/08/2022.
//

import Foundation

// MARK: - AverageResult

struct AverageResult: Equatable {
    
    enum Mode {
        case avgOf
        case meanOf
    }
    
    let solves: [Result]
    let best: Result
    let worst: Result
    let value: Double
}

// MARK: - Initialize

extension AverageResult {
    
    init?(mode: Mode, solves: [Result]) {
        guard let best = solves.best, let worst = solves.worst else { return nil }
        let value: Double
        switch mode {
        case .avgOf:
            value = AverageResult.averageOf(solves) ?? .zero
        case .meanOf:
            value = AverageResult.meanOf(solves) ?? .zero
        }
        self.solves = solves
        self.best = best
        self.worst = worst
        self.value = value
        
    }
    
    static private func averageOf(_ solves: [Result]) -> Double? {
        guard !solves.isEmpty else { return nil }
            
        var times = solves
            .map { $0.time }
            .sorted()
        
        times.removeFirst()
        times.removeFirst()
        return times.average
    }
    
    static private func meanOf(_ solves: [Result]) -> Double? {
        guard !solves.isEmpty else { return nil }
        
        return solves
            .map { $0.time }
            .average
    }
}
