//
//  TimerViewFeature.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 17/10/2022.
//

import Foundation
import ComposableArchitecture
import SwiftUI

private enum Configuration {
    static let timeIntervalNanoseconds: UInt64 = 10
    static let preinspectionTimeIntervalNanoseconds: UInt64 = 1000
    static let preinpectionSeconds: Double = 15.00
}

struct TimerFeature: ReducerProtocol {
    
    // MARK: - State
    
    struct State: Equatable {
        var cubingState: CubingState
        var time: Double
        var cube: Cube
        var scramble: String
        var isPreinspectionOn: Bool
        
        var formattedTime: String {
            if cubingState == .preinspectionOngoing || cubingState == .preinspectionReady {
                return time.asTextOnlyFractionalPart
            } else {
                return time.asTextWithTwoDecimal
            }
        }
    }
    
    // MARK: - Timer
    
    struct TimerID: Hashable { }
    
    // MARK: - Action
    
    enum Action {
        case touchBegan
        case touchEnded
        case updateTime(_ time: Double)
    }
    
    // MARK: - Reducer
    
    func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        
//        case .cubeChanged
//            self.cube = new
//        case .isPreinspectionOnChanged(let isOn):
//            self.isPreinspection = isOn
        
        switch (state.cubingState, action) {
        case (.idle, .touchBegan):
            state.cubingState = .ready
            state.time = .zero
            return .none
            
        case (.ready, .touchEnded):
            state.cubingState = state.isPreinspectionOn ? .preinspectionOngoing : .ongoing
            state.time = state.isPreinspectionOn ? Configuration.preinpectionSeconds : state.time
            
            let startDate = Date()
            let runPreinspectionTimer = state.isPreinspectionOn
            return Effect.run { send in
                while true {
                    try await Task.sleep(
                        nanoseconds: runPreinspectionTimer ? Configuration.preinspectionTimeIntervalNanoseconds : Configuration.timeIntervalNanoseconds
                    )
                    await send(
                        .updateTime(
                            runPreinspectionTimer ? Configuration.preinpectionSeconds - (Date().timeIntervalSince1970 - startDate.timeIntervalSince1970) : Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
                        )
                    )
                }
            }
            .cancellable(id: TimerID())
            
        case (.ongoing, .touchBegan):
            state.cubingState = .ended
            return .merge(
                [
                    .cancel(id: TimerID()),
//                    .saveResult(
//                            Result(time: state.time,
//                                   scramble: state.scramble,
//                                   date: .init())
                    
//                    )
                ]
            )
            
        case (.preinspectionOngoing, .touchBegan):
            state.cubingState = .preinspectionReady
            return .none
            
        case (.preinspectionReady, .touchEnded):
            state.cubingState = .ongoing
            
            let startDate = Date()
            return Effect.run { send in
                while true {
                    try await Task.sleep(nanoseconds: Configuration.timeIntervalNanoseconds)
                    await send(
                        .updateTime(
                            Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
                        )
                    )
                }
            }
            .cancellable(id: TimerID())

        case (.ended, .touchEnded):
            state.cubingState = .idle
            state.scramble = ScrambleProvider.newScramble(for: state.cube)
            return .none
            
        case (_, .updateTime(let newTime)):
            state.time = newTime
            return .none
            
        default:
            return .none
            
        }
    }
}

extension TimerFeature {
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
