//
//  SpeedcubeTimerApp.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/03/2022.
//

import SwiftUI
import ComposableArchitecture

struct Middlewares { }
 
@main
struct SpeedcubeTimerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(
                store: Store(
                    initialState: MainFeature.State(),
                    reducer: MainFeature.reducer,
                    environment: .init(
                        sessionsManager: SessionsManager()
                    )
                )
            )
            .preferredColorScheme(.dark)
        }
    }
}

protocol SessionsManaging {
    var allSessions: [CubingSession] { get set }
    var currentSession: CubingSession { get set }
    
    func session(for cube: Cube, and index: Int) -> CubingSession
    func session(for cube: Cube) -> CubingSession
    func sessionForCurrentCube(and index: Int) -> CubingSession
    func setCurrentSession(_ session: CubingSession)
    func setNameForCurrentSession(_ name: String)
}

final class SessionsManager: SessionsManaging {
    var allSessions: [CubingSession]
    var currentSession: CubingSession
    
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
        currentSession.name = (name == .empty) ? nil : name
        allSessions.removeAll { $0.id == currentSession.id }
        allSessions.append(currentSession)
    }
}
