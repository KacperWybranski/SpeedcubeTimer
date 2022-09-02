//
//  AppScreenState.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 26/04/2022.
//

import Foundation

// MARK: - App Screen State

enum AppScreenState: Equatable {
    case main(MainViewState)
    case timerScreen(TimerViewState)
    case resultsScreen(ResultsViewState)
    case settingsScreen(SettingsViewState)
}

// MARK: - Screen State Reducer

extension AppScreenState {
    static let reducer: Reducer<Self> = { state, action in
        
        switch state {
        case .main(let state):
            return .main(MainViewState.reducer(state, action))
        case .timerScreen(let state):
            return .timerScreen(TimerViewState.reducer(state, action))
        case .resultsScreen(let state):
            return .resultsScreen(ResultsViewState.reducer(state, action))
        case .settingsScreen(let state):
            return .settingsScreen(SettingsViewState.reducer(state, action))
        }
    }
}
