//
//  SettingsViewStateAction.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 04/05/2022.
//

import Foundation

enum SettingsViewStateAction: Action {
    case cubeChanged(_ cube: Cube)
    case sessionChanged(_ session: Int)
    case isPreinspectionOnChanged(_ isOn: Bool)
}
