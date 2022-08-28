//
//  TimerViewState.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 29/04/2022.
//

import Foundation
import SwiftUI

struct TimerViewState: Equatable {
    let cubingState: CubingState
    let time: Double
    let cube: Cube
    let scramble: String
    let isPreinspectionOn: Bool
    let isPresentingOverlay: Bool
}

extension TimerViewState {
    init() {
        cubingState = .idle
        time = .zero
        cube = .three
        scramble = ScrambleProvider.newScramble(for: cube)
        isPreinspectionOn = false
        isPresentingOverlay = false
    }
    
    init(session: CubingSession) {
        cubingState = .idle
        time = .zero
        cube = session.cube
        scramble = ScrambleProvider.newScramble(for: cube)
        isPreinspectionOn = false
        isPresentingOverlay = false
    }
}

extension TimerViewState {
    enum CubingState {
        case idle
        case ready
        case ongoing
        case ended
        
        case preinspectionReady
        case preinspectionOngoing
        
        var timerTextColor: Color {
            switch self {
            case .idle: return .white
            case .ready, .preinspectionReady: return .yellow
            case .ongoing: return .green
            case .ended: return .red
            case .preinspectionOngoing: return Color(red: 0, green: 1, blue: 1)
            }
        }
        
        var shouldScrambleBeHidden: Bool {
            switch self {
            case .idle, .ready, .preinspectionReady, .preinspectionOngoing:
                return false
            case .ongoing, .ended:
                return true
            }
        }
    }
}
