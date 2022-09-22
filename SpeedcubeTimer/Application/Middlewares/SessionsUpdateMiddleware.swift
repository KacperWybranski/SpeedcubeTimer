//
//  SessionsUpdateMiddleware.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 19/09/2022.
//

import Foundation
import Combine

extension Middlewares {
    static let sessionsUpdate: Middleware<AppState> = { state, action in
        switch action {
        case AppStateAction.newSessionSet(let newSession):
            var newAllSessions = state.allSessions
            newAllSessions.removeAll { $0.id == newSession.id }
            newAllSessions.append(newSession)
            return Just(
                AppStateAction
                    .newSessionsSet(current: newSession,
                                    allSessions: newAllSessions)
            )
            .eraseToAnyPublisher()
        case TimerViewStateAction.saveResult(let result):
            var newResults = state.currentSession.results
            newResults.insert(result, at: 0)
            let newSession = CubingSession(results: newResults,
                                           cube: state.currentSession.cube,
                                           index: state.currentSession.index,
                                           name: state.currentSession.name,
                                           id: state.currentSession.id)
            return Just(
                AppStateAction
                    .newSessionSet(current: newSession)
            )
            .eraseToAnyPublisher()
        case SettingsViewStateAction.currentSessionNameChanged(let name):
            let newSession = CubingSession(results: state.currentSession.results,
                                           cube: state.currentSession.cube,
                                           index: state.currentSession.index,
                                           name: (name == .empty ? nil : name),
                                           id: state.currentSession.id)
            return Just(
                AppStateAction
                    .newSessionSet(current: newSession)
            )
            .eraseToAnyPublisher()
        case SettingsViewStateAction.cubeChanged(let cube):
            let newSession = state.session(for: cube, and: state.currentSession.index)
            return Just(
                AppStateAction
                    .newSessionSet(current: newSession)
            )
            .eraseToAnyPublisher()
        case SettingsViewStateAction.sessionIndexChanged(let newIndex):
            let newSession = state.session(for: state.currentSession.cube, and: newIndex)
            return Just(
                AppStateAction
                    .newSessionSet(current: newSession)
            )
            .eraseToAnyPublisher()
        case SettingsViewStateAction.eraseSession:
            let newSession = CubingSession(results: [],
                                           cube: state.currentSession.cube,
                                           index: state.currentSession.index,
                                           name: nil,
                                           id: state.currentSession.id)
            return Just(
                AppStateAction
                    .newSessionSet(current: newSession)
            )
            .eraseToAnyPublisher()
        case ResultsViewStateAction.removeResultsAt(let offsets):
            var newResults = state.currentSession.results
            newResults.remove(atOffsets: offsets)
            let newSession = CubingSession(results: newResults,
                                           cube: state.currentSession.cube,
                                           index: state.currentSession.index,
                                           name: state.currentSession.name,
                                           id: state.currentSession.id)
            return Just(
                AppStateAction
                    .newSessionSet(current: newSession)
            )
            .eraseToAnyPublisher()
        case SettingsViewStateAction.resetApp:
            let newSession = CubingSession.initialSession
            let newAllSessions = [newSession]
            return Just(
                AppStateAction
                    .newSessionsSet(current: newSession,
                                    allSessions: newAllSessions)
            )
            .eraseToAnyPublisher()
        default:
            return Empty()
                .eraseToAnyPublisher()
        }
    }
}

private extension AppState {
    func session(for cube: Cube, and index: Int) -> CubingSession {
        if let session = allSessions.filter({ $0.cube == cube && $0.index == index }).first {
            return session
        } else {
            return CubingSession(results: [], cube: cube, index: index)
        }
    }
}
