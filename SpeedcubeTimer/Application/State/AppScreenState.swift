//
//  AppScreenState.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 26/04/2022.
//

import Foundation

enum AppScreenState: Codable, Equatable {
    case timerScreen(TimerViewState)
}

extension AppScreenState {
    static let reducer: Reducer<Self> = { state, action in
        
        switch state {
        case .timerScreen(let state):
            return .timerScreen(TimerViewState.reducer(state, action))
        }
    }
}
