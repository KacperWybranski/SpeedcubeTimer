//
//  Model.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 11/04/2022.
//

import Foundation

// MARK: - Cube

@objc
public enum Cube: Int16, CaseIterable, Codable {
    case two
    case three
    case four
}

extension Cube {
    var name: String {
        switch self {
        case .two: return "2x2"
        case .three: return "3x3"
        case .four: return "4x4"
        }
    }
}
