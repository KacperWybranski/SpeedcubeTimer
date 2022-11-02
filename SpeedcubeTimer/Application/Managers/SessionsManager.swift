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
    func saveResult(_ result: Result, andIfNewPB completion: (OverlayManager.RecordType) -> Void)
    func removeResults(at offsets: IndexSet)
}

final class SessionsManager: SessionsManaging {
    let overlayManager: OverlayManager = .init()
    
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
    
    func saveResult(_ result: Result, andIfNewPB completion: (OverlayManager.RecordType) -> Void) {
        var newCurrentSession = currentSession
        newCurrentSession
            .results
            .append(result)
        overlayManager
            .checkForNewRecord(
                oldSession: currentSession,
                newSession: newCurrentSession,
                completion: completion
            )
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
