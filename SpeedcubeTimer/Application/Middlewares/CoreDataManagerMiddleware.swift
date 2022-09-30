//
//  CoreDataManagerMiddleware.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 19/09/2022.
//

import Combine

extension Middlewares {
    static private let dataController = DataController()
    
    static let coreDataManager: Middleware<AppState> = { state, action in
        switch action {
        case AppStateAction.loadSessions:
            let sessions = dataController
                                    .loadSessions()
            let currentSession = sessions
                                    .first {
                                        $0.cube == state.currentSession.cube &&
                                        $0.index == state.currentSession.index
                                    } ?? state.currentSession
            
            return Just(
                AppStateAction
                    .newSessionsSet(
                        previous: state.currentSession,
                        current: currentSession,
                        allSessions: sessions)
            )
            .eraseToAnyPublisher()
        case TimerViewStateAction.saveResult(let result):
            dataController
                .save(result,
                      to: state.currentSession)
            return Just(
                AppStateAction
                    .loadSessions
            )
            .eraseToAnyPublisher()
        case ResultsViewStateAction.removeResultsAt(let offsets):
            offsets
                .forEach { index in
                    dataController
                        .remove(
                            result: state
                                    .currentSession
                                    .results[index],
                            from: state
                                    .currentSession
                        )
                }
            return Just(
                AppStateAction
                    .loadSessions
            )
            .eraseToAnyPublisher()
        case SettingsViewStateAction.currentSessionNameChanged(let name):
            dataController
                .changeName(
                    of: state.currentSession,
                    to: name.isEmpty ? nil : name
                )
            
            return Just(
                AppStateAction
                    .loadSessions
            )
            .eraseToAnyPublisher()
        case SettingsViewStateAction.eraseSession(let session):
            dataController
                .erase(
                    session: session
                )
            return Just(
                AppStateAction
                    .loadSessions
            )
            .eraseToAnyPublisher()
        case SettingsViewStateAction.resetApp:
            dataController
                .reset()
            let newSession = CubingSession.initialSession
            return Just(
                AppStateAction
                    .newSessionsSet(
                        previous: state.currentSession,
                        current: newSession,
                        allSessions: [newSession])
            )
            .eraseToAnyPublisher()
        default:
            break
        }
        
        return Empty()
            .eraseToAnyPublisher()
    }
}
