//
//  ResultsViewState.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 16/05/2022.
//

import Foundation

struct ResultsViewState: Equatable {
    let currentSession: CubingSession
    var currentAvg5: AverageResult? {
        currentSession.avgOfLast(5)
    }
    var currentAvg12: AverageResult? {
        currentSession.avgOfLast(12)
    }
    var currentMean100: AverageResult? {
        currentSession.meanOfLast(100)
    }
}

extension ResultsViewState {
    init() {
        currentSession = .init()
    }
}
