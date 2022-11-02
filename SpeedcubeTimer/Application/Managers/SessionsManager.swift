//
//  SessionsUpdateMiddleware.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 19/09/2022.
//

import Foundation
import Combine

protocol SessionsManaging {
    var allSessions: [CubingSession] { get set }
    var currentSession: CubingSession { get set }
    
    func session(for cube: Cube, and index: Int) -> CubingSession
    func session(for cube: Cube) -> CubingSession
    func sessionForCurrentCube(and index: Int) -> CubingSession
    func setCurrentSession(_ session: CubingSession)
    func setNameForCurrentSession(_ name: String)
    func saveResult(_ result: Result)
    func removeResults(at offsets: IndexSet)
}

final class SessionsManager: SessionsManaging {
    var allSessions: [CubingSession]
    var currentSession: CubingSession
    
    init(session: CubingSession) {
        allSessions = [session]
        currentSession = session
    }
    
    init() {
        let initial = CubingSession.initialSession
        allSessions = [initial]
        currentSession = initial
    }
    
    func session(for cube: Cube, and index: Int) -> CubingSession {
        allSessions
            .filter {
                $0.cube == cube &&
                $0.index == index
            }
            .first ??
        CubingSession(
            results: [],
            cube: cube,
            index: index
        )
    }
    
    func session(for cube: Cube) -> CubingSession {
        session(for: cube, and: currentSession.index)
    }
    
    func sessionForCurrentCube(and index: Int) -> CubingSession {
        session(for: currentSession.cube, and: index)
    }
    
    func setCurrentSession(_ session: CubingSession) {
        currentSession = session
        allSessions.removeAll { $0.id == session.id }
        allSessions.append(session)
    }
    
    func setNameForCurrentSession(_ name: String) {
        var newCurrentSession = currentSession
        newCurrentSession.name = (name == .empty) ? nil : name
        setCurrentSession(newCurrentSession)
    }
    
    func saveResult(_ result: Result) {
        var newCurrentSession = currentSession
        newCurrentSession
            .results
            .append(result)
        setCurrentSession(newCurrentSession)
    }
    
    func removeResults(at offsets: IndexSet) {
        var newCurrentSession = currentSession
        newCurrentSession
            .results
            .remove(atOffsets: offsets)
        setCurrentSession(newCurrentSession)
    }
}


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
