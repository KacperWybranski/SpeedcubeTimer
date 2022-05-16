//
//  ResultsViewState.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 16/05/2022.
//

import Foundation

struct ResultsViewState: Equatable {
    let currentSession: CubingSession
}

extension ResultsViewState {
    init() {
        currentSession = .init()
    }
}
