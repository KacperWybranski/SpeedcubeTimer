//
//  AppStateAction.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 17/08/2022.
//

import Foundation

// MARK: - Action

enum AppStateAction: Action {
    case loadSessions
    case newSessionSet(current: CubingSession)
    case newSessionsSet(previous: CubingSession, current: CubingSession, allSessions: [CubingSession])
}
