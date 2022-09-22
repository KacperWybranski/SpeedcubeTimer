//
//  Model.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 11/04/2022.
//

import Foundation

// MARK: - Cube

enum Cube: CaseIterable, Codable {
    case two
    case three
    case four
}

// MARK: - SelectionType

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
        case .four: return "4x4"
        }
    }
}
