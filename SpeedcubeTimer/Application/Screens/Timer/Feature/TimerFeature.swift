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
    static let timeInterval: TimeInterval = 0.01
    static let preinspectionTimeInterval: TimeInterval = 1
    static let preinpectionSeconds: TimeInterval = 15.00
}

struct TimerFeature {
    
    // MARK: - State
    
    struct State: Equatable {
        var cubingState: CubingState = .idle
        var time: Double = 0.0
        var cube: Cube = .three
        var scramble: String = ScrambleProvider.newScramble(for: .three)
        var isPreinspectionOn: Bool = false
        
        var formattedTime: String {
            if cubingState == .preinspectionOngoing || cubingState == .preinspectionReady {
                return time.asTextOnlyFractionalPart
            } else {
                return time.asTextWithTwoDecimal
            }
        }
    }
    
    // MARK: - Action
    
    enum Action {
        case loadSession
        case sessionLoaded(_ current: CubingSession)
        case touchBegan
        case touchEnded
        case updateTime(_ time: Double)
    }
    
    // MARK: - Environment
    
    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let sessionsManager: SessionsManaging
    }
    
    // MARK: - Reducer
    
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        struct TimerID: Hashable {}
        
        switch (state.cubingState, action) {
        case (_, .loadSession):
            return .run { @MainActor send in
                send(
                    .sessionLoaded(
                        environment
                            .sessionsManager
                            .currentSession
                    )
                )
            }
            
        case (_, .sessionLoaded(let newCurrent)):
            if state.cube != newCurrent.cube {
                state.cube = newCurrent.cube
                state.scramble = ScrambleProvider.newScramble(for: newCurrent.cube)
            }
            return .none
            
        case (.idle, .touchBegan):
            state.cubingState = .ready
            state.time = .zero
            return .none
            
        case (.ready, .touchEnded):
            state.cubingState = state.isPreinspectionOn ? .preinspectionOngoing : .ongoing
            state.time = state.isPreinspectionOn ? Configuration.preinpectionSeconds : state.time
            
            let startDate = Date()
            let runPreinspectionTimer = state.isPreinspectionOn
            let interval = runPreinspectionTimer ? Configuration.preinspectionTimeInterval : Configuration.timeInterval
            
            return Effect
                .timer(
                    id: TimerID(),
                    every: .init(floatLiteral: interval),
                    on: environment.mainQueue
                )
                .map { _ in
                    .updateTime(runPreinspectionTimer ? Configuration.preinpectionSeconds - (Date().timeIntervalSince1970 - startDate.timeIntervalSince1970) : Date().timeIntervalSince1970 - startDate.timeIntervalSince1970)
                }
            
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
            
            return Effect
                .timer(
                    id: TimerID(),
                    every: .init(floatLiteral: Configuration.timeInterval),
                    on: environment.mainQueue
                )
                .map { _ in
                    .updateTime(
                        Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
                    )
                }

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
