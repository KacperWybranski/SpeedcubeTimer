//
//  SettingsViewState.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 02/09/2022.
//

import SwiftUI

// MARK: - SettingsViewState

struct SettingsViewState: Equatable {
    let allSessions: [CubingSession]
    let currentSession: CubingSession
    let isPreinspectionOn: Bool
    let isPresentingEraseSessionPopup: Bool
    let isPresentingResetActionSheet: Bool
    let isPresentingResetAppPopup: Bool
    
    static let availableCubes: [Cube] = Cube.allCases
    static let availableSessionNums: [Int] = Array(1...10)
    
    func identifierForSession(with index: Int) -> String? {
        allSessions
            .filter { $0.cube == currentSession.cube && $0.index == index }
            .first?
            .name
    }
}

// MARK: - Intialize

extension SettingsViewState {
    init() {
        let session = CubingSession()
        allSessions = [session]
        currentSession = session
        isPreinspectionOn = false
        isPresentingEraseSessionPopup = false
        isPresentingResetActionSheet = false
        isPresentingResetAppPopup = false
    }
    
    init(allSessions: [CubingSession]) {
        self.allSessions = allSessions
        self.currentSession = allSessions.first ?? .init()
        self.isPreinspectionOn = false
        isPresentingEraseSessionPopup = false
        isPresentingResetActionSheet = false
        isPresentingResetAppPopup = false
    }
}
