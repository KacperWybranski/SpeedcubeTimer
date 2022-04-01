//
//  SettingsModel.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 26/03/2022.
//

import SwiftUI

protocol SelectionType {
    var name: String { get }
}

extension Int: SelectionType {
    var name: String { "\(self)" }
}

extension Cube: SelectionType {
    var name: String {
        switch self {
        case .two: return "2x2"
        case .three: return "3x3"
        }
    }
}
