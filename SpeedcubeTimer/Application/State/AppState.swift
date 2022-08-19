//
//  AppState.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 11/04/2022.
//

import SwiftUI

// MARK: - AppState

struct AppState {
    let allSessions: [CubingSession]
    let currentSession: CubingSession
    let screens: [AppScreenState]
}

// MARK: - Initialize

extension AppState {
    init() {
        currentSession = .initialSession
        allSessions = [currentSession]
        screens = [.timerScreen(TimerViewState(session: currentSession)), .resultsScreen(ResultsViewState())]
    }
    
    static func forPreview(screenStates: [AppScreenState], session: CubingSession) -> AppState {
        return AppState(allSessions: [session], currentSession: session, screens: screenStates)
    }
}

// MARK: - Equatable

extension AppState: Equatable {
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        lhs.screens == rhs.screens
    }
}

// MARK: - ScreenState

extension AppState {
    func screenState<State>(for screen: AppScreen) -> State? {
            return screens
                .compactMap {
                    switch ($0, screen) {
                    case (.timerScreen(let state), .timer):
                        return state as? State
                    case (.resultsScreen(let state), .resultsList):
                        return state as? State
                    default:
                        return nil
                    }
                }
                .first
        }
    
    enum AppScreen {
        case timer
        case resultsList
    }
}
