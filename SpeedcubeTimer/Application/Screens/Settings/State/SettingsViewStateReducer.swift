//
//  SettingsViewStateReducer.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 02/09/2022.
//

import Foundation

extension SettingsViewState {
    static let reducer: Reducer<Self> = { state, action in
        
        if let action = action as? AppStateAction {
            switch action {
            case .newAllSessionsSet(let allSessions):
                return SettingsViewState(allSessions: allSessions)
            default:
                break
            }
        }
        
        return state
    }
}
