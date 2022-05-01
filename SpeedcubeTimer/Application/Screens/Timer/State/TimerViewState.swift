//
//  TimerViewState.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 29/04/2022.
//

import Foundation
import SwiftUI

struct TimerViewState: Codable, Equatable {
    let cubingState: CubingState
    let time: Double
    let cube: Cube
    let scramble: String
}

extension TimerViewState {
    init() {
        cubingState = .idle
        time = .zero
        cube = .three
        scramble = ScrambleProvider.newScramble(for: cube)
    }
}

extension TimerViewState {
    enum CubingState: Codable {
        case idle
        case ready
        case ongoing
        case ended
        
        var timerTextColor: Color {
            switch self {
            case .idle: return .white
            case .ready: return .yellow
            case .ongoing: return .green
            case .ended: return .red
            }
        }
        
        var shouldScrambleBeHidden: Bool {
            switch self {
            case .idle, .ready:
                return false
            case .ongoing, .ended:
                return true
            }
        }
    }
}
