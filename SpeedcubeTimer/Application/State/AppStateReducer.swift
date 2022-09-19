//
//  AppStateReducer.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 17/08/2022.
//

import Foundation

// MARK: - App State Reducer

extension AppState {
    static let reducer: Reducer<Self> = { state, action in
        var newSession = state.currentSession
        var newAllSessions = state.allSessions
        
        switch action {
        case AppStateAction.newSessionsSet(let current, let all):
            newSession = current
            newAllSessions = all
        default:
            break
        }
        
        return AppState(allSessions: newAllSessions,
                        currentSession: newSession,
                        screens: state
                                    .screens
                                    .map {
                                        AppScreenState.reducer($0, action)
                                    })
    }
}
