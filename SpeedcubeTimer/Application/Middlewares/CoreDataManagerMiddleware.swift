//
//  CoreDataManagerMiddleware.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 19/09/2022.
//

import Combine

extension Middlewares {
    static let dataController = DataController()
    
    static let coreDataManager: Middleware<AppState> = { state, action in
        switch action {
        case TimerViewStateAction
                .saveResult(let result):
            dataController
                .save(result,
                      to: state.currentSession)
            return Just(
                AppStateAction
                    .loadSessions
            )
            .eraseToAnyPublisher()
        case AppStateAction
                .loadSessions:
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
                        current: currentSession,
                        allSessions: sessions)
            )
            .eraseToAnyPublisher()
        default:
            break
        }
        
        return Empty()
            .eraseToAnyPublisher()
    }
}
