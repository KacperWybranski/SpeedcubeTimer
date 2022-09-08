//
//  SettingsViewStateReducer.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 02/09/2022.
//

import Foundation

extension SettingsViewState {
    static let reducer: Reducer<Self> = { state, action in
        
        switch action {
        case AppStateAction.newSessionsSet(let newCurrent, let newAllSessions):
            return SettingsViewState(allSessions: newAllSessions,
                                     currentSession: newCurrent,
                                     isPreinspectionOn: state.isPreinspectionOn)
        case SettingsViewStateAction.isPreinspectionOnChanged(let isPreinspectionOn):
            return SettingsViewState(allSessions: state.allSessions,
                                     currentSession: state.currentSession,
                                     isPreinspectionOn: isPreinspectionOn)
        default:
            return state
        }
    }
}
