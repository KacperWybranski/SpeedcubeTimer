//
//  SessionsUpdateMiddleware.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 19/09/2022.
//

import Foundation
import Combine

//extension Middlewares {
//    static let sessionsUpdate: Middleware<AppState> = { state, action in
//        switch action {
//        case AppStateAction.newSessionSet(let newSession):
//            var newAllSessions = state.allSessions
//            newAllSessions.removeAll { $0.id == newSession.id }
//            newAllSessions.append(newSession)
//            return Just(
//                AppStateAction
//                    .newSessionsSet(previous: state.currentSession,
//                                    current: newSession,
//                                    allSessions: newAllSessions)
//            )
//            .eraseToAnyPublisher()
//        case SettingsViewStateAction.cubeChanged(let cube):
//            let newSession = state.session(for: cube, and: state.currentSession.index)
//            return Just(
//                AppStateAction
//                    .newSessionSet(current: newSession)
//            )
//            .eraseToAnyPublisher()
//        case SettingsViewStateAction.sessionIndexChanged(let newIndex):
//            let newSession = state.session(for: state.currentSession.cube, and: newIndex)
//            return Just(
//                AppStateAction
//                    .newSessionSet(current: newSession)
//            )
//            .eraseToAnyPublisher()
//        default:
//            return Empty()
//                .eraseToAnyPublisher()
//        }
//    }
//}

//private extension AppState {
//    func session(for cube: Cube, and index: Int) -> CubingSession {
//        if let session = allSessions.filter({ $0.cube == cube && $0.index == index }).first {
//            return session
//        } else {
//            return CubingSession(results: [], cube: cube, index: index)
//        }
//    }
//}
