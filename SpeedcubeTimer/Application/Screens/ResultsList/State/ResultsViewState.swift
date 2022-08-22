//
//  ResultsViewState.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 16/05/2022.
//

import Foundation

struct ResultsViewState: Equatable {
    let currentSession: CubingSession
    
    // MARK: - Current averages
    
    var currentAvg5: AverageResult? {
        currentSession.avgOfLast(5)
    }
    var currentAvg12: AverageResult? {
        currentSession.avgOfLast(12)
    }
    var currentMean100: AverageResult? {
        currentSession.meanOfLast(100)
    }
    
    // MARK: - Personal Bests
    
    var bestResult: Result? {
        currentSession.bestResult
    }
    
    var bestAvg5: AverageResult? {
        currentSession.bestAvgOf(5, mode: .avgOf)
    }
    
    var bestAvg12: AverageResult? {
        currentSession.bestAvgOf(12, mode: .avgOf)
    }
    
    var bestMean100: AverageResult? {
        currentSession.bestAvgOf(100, mode: .meanOf)
    }
}

extension ResultsViewState {
    init() {
        currentSession = .init()
    }
}
