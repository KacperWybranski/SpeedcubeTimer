//
//  AppStateAction.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 17/08/2022.
//

import Foundation

// MARK: - Action

enum AppStateAction: Action {
    case newSessionsSet(current: CubingSession, allSessions: [CubingSession])
}
