//
//  SettingsViewStateAction.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 04/05/2022.
//

import Foundation

enum SettingsViewStateAction: Action {
    case currentSessionNameChanged(_ name: String)
    case cubeChanged(_ cube: Cube)
    case sessionIndexChanged(_ session: Int)
    case isPreinspectionOnChanged(_ isOn: Bool)
    case showEraseSessionPopup(_ show: Bool)
    case eraseSession
}
