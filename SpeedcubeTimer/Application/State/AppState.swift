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
        screens = [
            .main(MainViewState()),
            .timerScreen(TimerViewState(session: currentSession)),
            .resultsScreen(ResultsViewState()),
            .settingsScreen(SettingsViewState(allSessions: allSessions))
        ]
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
                    case (.main(let state), .main):
                        return state as? State
                    case (.timerScreen(let state), .timer):
                        return state as? State
                    case (.resultsScreen(let state), .resultsList):
                        return state as? State
                    case (.settingsScreen(let state), .settings):
                        return state as? State
                    default:
                        return nil
                    }
                }
                .first
        }
    
    enum AppScreen {
        case main
        case timer
        case resultsList
        case settings
    }
}
