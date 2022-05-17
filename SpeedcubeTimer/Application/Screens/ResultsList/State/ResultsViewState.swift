//
//  ResultsViewState.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 16/05/2022.
//

import Foundation

struct ResultsViewState: Equatable {
    let currentSession: CubingSession
    var currentAvg5Text: String {
        currentSession.avgOfLast(5)?.asTextWithTwoDecimal ?? "-"
    }
    var currentAvg12Text: String {
        currentSession.avgOfLast(12)?.asTextWithTwoDecimal ?? "-"
    }
    var currentMeanOf100Text: String {
        currentSession.meanOfLast(100)?.asTextWithTwoDecimal ?? "-"
    }
}

extension ResultsViewState {
    init() {
        currentSession = .init()
    }
}
