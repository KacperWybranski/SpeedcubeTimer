//
//  SessionsManager+Mocks.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 24/12/2022.
//

import Foundation
@testable import SpeedcubeTimer

final class MockSessionsManager: SessionsManaging {
    
    // MARK: - SessionsManaging
    
    func loadSessions() -> (all: [CubingSession], current: CubingSession) {
        if let source = sessionsSource {
            return source()
        } else {
            let session = CubingSession()
            return ([session], session)
        }
    }
    
    func session(for cube: Cube, and index: Int) -> CubingSession {
        return .initialSession
    }
    
    func session(for cube: Cube) -> CubingSession {
        return .initialSession
    }
    
    func sessionForCurrentCube(and index: Int) -> CubingSession {
        return .initialSession
    }
    
    func setCurrentSession(_ session: CubingSession) {
        
    }
    
    func setNameForCurrentSession(_ name: String) {
        
    }
    
    func saveResultAndCheckForPb(_ result: Result) -> OverlayManager.RecordType {
        checkForPbResult
    }
    
    func removeResults(at offsets: IndexSet) {
        onRemoveResults?(offsets)
    }
    
    func erase(session: SpeedcubeTimer.CubingSession) {
        
    }
    
    func resetApp() {
        
    }
    
    // MARK: - Configuration
    
    var sessionsSource: (() -> (all: [CubingSession], current: CubingSession))?
    var onRemoveResults: ((IndexSet) -> ())?
    var checkForPbResult: OverlayManager.RecordType = .none
    
}
