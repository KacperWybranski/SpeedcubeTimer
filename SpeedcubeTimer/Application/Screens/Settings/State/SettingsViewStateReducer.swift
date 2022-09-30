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
        case AppStateAction.newSessionsSet(_, let newCurrent, let newAllSessions):
            return SettingsViewState(allSessions: newAllSessions,
                                     currentSession: newCurrent,
                                     isPreinspectionOn: state.isPreinspectionOn,
                                     isPresentingEraseSessionPopup: state.isPresentingEraseSessionPopup,
                                     isPresentingResetActionSheet: state.isPresentingResetActionSheet,
                                     isPresentingResetAppPopup: state.isPresentingResetAppPopup)
        case SettingsViewStateAction.isPreinspectionOnChanged(let isPreinspectionOn):
            return SettingsViewState(allSessions: state.allSessions,
                                     currentSession: state.currentSession,
                                     isPreinspectionOn: isPreinspectionOn,
                                     isPresentingEraseSessionPopup: state.isPresentingEraseSessionPopup,
                                     isPresentingResetActionSheet: state.isPresentingResetActionSheet,
                                     isPresentingResetAppPopup: state.isPresentingResetAppPopup)
        case SettingsViewStateAction.showEraseSessionPopup(let show):
            return SettingsViewState(allSessions: state.allSessions,
                                     currentSession: state.currentSession,
                                     isPreinspectionOn: state.isPreinspectionOn,
                                     isPresentingEraseSessionPopup: show,
                                     isPresentingResetActionSheet: state.isPresentingResetActionSheet,
                                     isPresentingResetAppPopup: state.isPresentingResetAppPopup)
        case SettingsViewStateAction.showResetActionSheet(let show):
            return SettingsViewState(allSessions: state.allSessions,
                                     currentSession: state.currentSession,
                                     isPreinspectionOn: state.isPreinspectionOn,
                                     isPresentingEraseSessionPopup: state.isPresentingEraseSessionPopup,
                                     isPresentingResetActionSheet: show,
                                     isPresentingResetAppPopup: state.isPresentingResetAppPopup)
        case SettingsViewStateAction.showResetAppPopup(let show):
            return SettingsViewState(allSessions: state.allSessions,
                                     currentSession: state.currentSession,
                                     isPreinspectionOn: state.isPreinspectionOn,
                                     isPresentingEraseSessionPopup: state.isPresentingEraseSessionPopup,
                                     isPresentingResetActionSheet: state.isPresentingResetActionSheet,
                                     isPresentingResetAppPopup: show)
        default:
            return state
        }
    }
}
