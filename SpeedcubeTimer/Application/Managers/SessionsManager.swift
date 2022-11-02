//
//  SessionsUpdateMiddleware.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 19/09/2022.
//

import Foundation
import Combine

protocol SessionsManaging {
    func loadSessions() -> (all: [CubingSession], current: CubingSession)
    func session(for cube: Cube, and index: Int) -> CubingSession
    func session(for cube: Cube) -> CubingSession
    func sessionForCurrentCube(and index: Int) -> CubingSession
    func setCurrentSession(_ session: CubingSession)
    func setNameForCurrentSession(_ name: String)
    func saveResult(_ result: Result, andIfNewPB completion: (OverlayManager.RecordType) -> Void)
    func removeResults(at offsets: IndexSet)
}

final class SessionsManager: SessionsManaging {
    private let overlayManager: OverlayManager = .init()
    private let coreDataController: DataController = .init()
    
    private var allSessions: [CubingSession]
    private var currentSession: CubingSession
    
    init(session: CubingSession) {
        allSessions = [session]
        currentSession = session
    }
    
    init() {
        let initial = CubingSession.initialSession
        allSessions = [initial]
        currentSession = initial
    }
    
    @discardableResult
    func loadSessions() -> (all: [CubingSession], current: CubingSession) {
        let sessions = coreDataController
                                    .loadSessions()
        let newCurrent = sessions
                            .first {
                                $0.cube == currentSession.cube &&
                                $0.index == currentSession.index
                            } ?? currentSession
        allSessions = sessions
        currentSession = newCurrent
        return (allSessions, currentSession)
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
        coreDataController
            .changeName(
                of: currentSession,
                to: name.isEmpty ? nil : name
            )
        
        loadSessions()
    }
    
    func saveResult(_ result: Result, andIfNewPB completion: (OverlayManager.RecordType) -> Void) {
        let oldSession = currentSession
        
        coreDataController
            .save(result,
                  to: oldSession)
        
        loadSessions()
        
        overlayManager
            .checkForNewRecord(
                oldSession: oldSession,
                newSession: currentSession,
                completion: completion
            )
    }
    
    func removeResults(at offsets: IndexSet) {
        offsets
            .forEach { index in
                coreDataController
                        .remove(
                            result: currentSession.results[index],
                            from: currentSession
                        )
            }
        
        loadSessions()
    }
}
