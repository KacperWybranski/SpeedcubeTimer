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
    
    func loadSessions() -> (all: [SpeedcubeTimer.CubingSession], current: SpeedcubeTimer.CubingSession) {
        if let source = sessionsSource {
            return source()
        } else {
            let session = CubingSession()
            return ([session], session)
        }
    }
    
    func session(for cube: SpeedcubeTimer.Cube, and index: Int) -> SpeedcubeTimer.CubingSession {
        return .initialSession
    }
    
    func session(for cube: SpeedcubeTimer.Cube) -> SpeedcubeTimer.CubingSession {
        return .initialSession
    }
    
    func sessionForCurrentCube(and index: Int) -> SpeedcubeTimer.CubingSession {
        return .initialSession
    }
    
    func setCurrentSession(_ session: SpeedcubeTimer.CubingSession) {
        
    }
    
    func setNameForCurrentSession(_ name: String) {
        
    }
    
    func saveResultAndCheckForPb(_ result: SpeedcubeTimer.Result) -> SpeedcubeTimer.OverlayManager.RecordType {
        .none
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
    
}
