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
        
        if let action = action as? SettingsViewStateAction {
            switch action {
            case .cubeChanged(let newCube):
                let tmpNewSession = state.session(for: newCube, and: state.currentSession.index)
                let tmpAllSessions: [CubingSession] = {
                    if !state.allSessions.contains(tmpNewSession) {
                        return state.allSessions + [tmpNewSession]
                    } else {
                        return state.allSessions
                    }
                }()
                newSession = tmpNewSession
                newAllSessions = tmpAllSessions
                newActions = [AppStateAction.newSessionSet(newSession)]
            case .sessionIndexChanged(let newIndex):
                let tmpNewSession = state.session(for: state.currentSession.cube, and: newIndex)
                let tmpAllSessions: [CubingSession] = {
                    if !state.allSessions.contains(tmpNewSession) {
                        return state.allSessions + [tmpNewSession]
                    } else {
                        return state.allSessions
                    }
                }()
                newSession = tmpNewSession
                newAllSessions = tmpAllSessions
                newActions = [AppStateAction.newSessionSet(newSession)]
            default:
                break
            }
        }
        
        if let action = action as? TimerViewStateAction {
            switch action {
            case .saveResult(let newResult):
                let oldSession = state.currentSession
                var newResults = oldSession.results
                newResults.insert(newResult, at: 0)
                newSession = .init(results: newResults,
                                   cube: oldSession.cube,
                                   index: oldSession.index,
                                   id: oldSession.id)
                
                newAllSessions.removeAll { $0.id == oldSession.id }
                newAllSessions.append(newSession)
                newActions = [AppStateAction.newSessionSet(newSession)]
                if newSession.bestResult == newResult {
                    newActions.append(MainViewStateAction.showOverlay)
                }
            default:
                break
            }
        }
        
        if let action = action as? ResultsViewStateAction {
            switch action {
            case .removeResultsAt(let offsets):
                let oldSession = state.currentSession
                var newResults = oldSession.results
                newResults.remove(atOffsets: offsets)
                newSession = .init(results: newResults,
                                   cube: oldSession.cube,
                                   index: oldSession.index,
                                   id: oldSession.id)
                
                newAllSessions.removeAll { $0.id == oldSession.id }
                newAllSessions.append(newSession)
                newActions = [AppStateAction.newSessionSet(newSession)]
            }
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
