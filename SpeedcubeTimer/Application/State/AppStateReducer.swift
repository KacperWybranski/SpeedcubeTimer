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
        var newActions = [action]
        
        switch action {
        case AppStateAction.newSessionsSet(let current, let all):
            newSession = current
            newAllSessions = all
        case SettingsViewStateAction.currentSessionNameChanged(let name):
            newSession = .init(results: newSession.results,
                               cube: newSession.cube,
                               index: newSession.index,
                               name: (name == .empty ? nil : name),
                               id: newSession.id)
            
            newActions = [
                AppStateAction.newSessionSet(current: newSession)
            ]
        case SettingsViewStateAction.cubeChanged(let newCube):
            newSession = state.session(for: newCube, and: state.currentSession.index)
            newActions = [
                AppStateAction.newSessionSet(current: newSession)
            ]
        case SettingsViewStateAction.sessionIndexChanged(let newIndex):
            newSession = state.session(for: state.currentSession.cube, and: newIndex)
            newActions = [
                AppStateAction.newSessionSet(current: newSession)
            ]
        case SettingsViewStateAction.eraseSession:
            newSession = .init(results: [],
                               cube: newSession.cube,
                               index: newSession.index,
                               name: nil,
                               id: newSession.id)
            
            newActions = [
                AppStateAction.newSessionSet(current: newSession)
            ]
        case SettingsViewStateAction.resetApp:
            newSession = .initialSession
            newAllSessions = [newSession]
            let screens: [AppScreenState] = [
                .main(state.screenState(for: .main) ?? MainViewState()),
                .timerScreen(TimerViewState(session: newSession)),
                .resultsScreen(ResultsViewState()),
                .settingsScreen(SettingsViewState(allSessions: newAllSessions))
            ]
            return AppState(allSessions: newAllSessions, currentSession: newSession, screens: screens)
        case ResultsViewStateAction.removeResultsAt(let offsets):
            let oldSession = state.currentSession
            var newResults = oldSession.results
            newResults.remove(atOffsets: offsets)
            newSession = .init(results: newResults,
                               cube: oldSession.cube,
                               index: oldSession.index,
                               name: oldSession.name,
                               id: oldSession.id)
            newActions = [
                AppStateAction.newSessionSet(current: newSession)
            ]
        default:
            break
        }
        
        let newScreens = state.screens.map { (screenState: AppScreenState) -> AppScreenState in
            var finalState: AppScreenState = screenState
            newActions.forEach { action in
                finalState = AppScreenState.reducer(finalState, action)
            }
            return finalState
        }
        
        return AppState(allSessions: newAllSessions,
                        currentSession: newSession,
                        screens: newScreens)
    }
    
    private func session(for cube: Cube, and index: Int) -> CubingSession {
        if let session = allSessions.filter({ $0.cube == cube && $0.index == index }).first {
            return session
        } else {
            return CubingSession(results: [], cube: cube, index: index)
        }
    }
}
