//
//  AppSettings.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 01/04/2022.
//

import SwiftUI

class AppSettings: ObservableObject {
    private var allSessions: [CubingSession]
    
    @Published var currentSession: CubingSession = .initialSession
    @Published var isPreinspectionOn: Bool = false
    
    init(sessions: [CubingSession]) {
        allSessions = sessions
        
        if let first = sessions.first {
            currentSession = first
        } else {
            setNewSession(cube: .three, index: 1)
        }
    }
    
    private func setNewSession(cube: Cube, index: Int) {
        let newSession = CubingSession(results: [], cube: cube, session: index)
        allSessions.append(newSession)
        currentSession = newSession
    }
    
    func changeSessionTo(cube: Cube, index: Int) {
        if let session = allSessions.first(where: { $0.cube == cube && $0.sessionindex == index }) {
            currentSession = session
        } else {
            setNewSession(cube: cube, index: index)
        }
    }
}
