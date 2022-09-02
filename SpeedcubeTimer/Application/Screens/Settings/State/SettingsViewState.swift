//
//  SettingsViewState.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 02/09/2022.
//

import Foundation

struct SettingsViewState: Equatable {
    let allSessions: [CubingSession]
    
    static let availableCubes: [Cube] = Cube.allCases
    static let availableSessionNums: [Int] = Array(1...10)
    
    func identifierForSession(with cube: Cube, and index: Int) -> String? {
        allSessions
            .filter { $0.cube == cube && $0.index == index }
            .first?
            .name
    }
}

extension SettingsViewState {
    init() {
        allSessions = [.init()]
    }
}


