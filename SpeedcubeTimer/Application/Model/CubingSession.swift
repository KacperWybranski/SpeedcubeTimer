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
        
        return .init(mode: .meanOf, solves: Array(results.prefix(count)))
    }
    
    func bestAvgOf(_ count: Int, mode: AverageResult.Mode) -> AverageResult? {
        guard results.count >= count else { return nil}
        
        return results
            .dropLast(count-1)
            .compactMap { (result) -> AverageResult? in
                guard let firstIndex = results.firstIndex(of: result) else { return nil }
                let solvesToCount: [Result] = {
                    (0..<count)
                        .map {
                            results[firstIndex + $0]
                        }
                }()
                return AverageResult(mode: mode, solves: solvesToCount)
            }
            .sorted {
                $0.value < $1.value
            }
            .first
    }
}

extension CubingSession {
    static var initialSession: CubingSession {
        .init(results: [], cube: .three, index: 1)
    }
}
