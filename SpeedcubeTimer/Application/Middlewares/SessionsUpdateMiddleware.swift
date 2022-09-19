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
                AppStateAction.newSessionSet(current: newSession)
            )
            .eraseToAnyPublisher()
        default:
            return Empty().eraseToAnyPublisher()
        }
    }
}
