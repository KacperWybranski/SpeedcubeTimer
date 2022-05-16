//
//  AppState.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 11/04/2022.
//

import SwiftUI

// MARK: - New Redux AppState

struct AppState {
    let screens: [AppScreenState]
}

extension AppState {
    init() {
        screens = [.timerScreen(TimerViewState()), .resultsScreen(ResultsViewState())]
    }
}

extension AppState: Equatable {
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        lhs.screens == rhs.screens
    }
}

extension AppState {
    static let reducer: Reducer<Self> = { state, action in
        let screens = state.screens.map {
            AppScreenState.reducer($0, action)
        }
        return AppState(screens: screens)
    }
}

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
