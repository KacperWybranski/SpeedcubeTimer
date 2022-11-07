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
        var alert: AlertState<Action>?
        
        var formattedTime: String {
            if cubingState == .preinspectionOngoing || cubingState == .preinspectionReady {
                return time.asTextOnlyFractionalPart
            } else {
                return time.asTextWithTwoDecimal
            }
        }
    }
    
    // MARK: - Action
    
    enum Action: Equatable {
        case loadSession
        case sessionLoaded(_ current: CubingSession)
        case touchBegan
        case touchEnded
        case updateTime(_ time: Double)
        case showSafeCheckPopup(_ result: Result)
        case dismissPopup
        case saveResult(_ result: Result)
        case newRecordSet(_ type: OverlayManager.RecordType)
    }
    
    // MARK: - Environment
    
    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let overlayCheckPriority: TaskPriority
        let sessionsManager: SessionsManaging
        let userSettings: UserSettingsProtocol
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
                            .loadSessions()
                            .current
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
            let isPreinspectionOn = environment
                .userSettings
                .isPreinspectionOn
            state.cubingState = isPreinspectionOn ? .preinspectionOngoing : .ongoing
            state.time = isPreinspectionOn ? Configuration.preinpectionSeconds : state.time
            
            let startDate = Date()
            let runPreinspectionTimer = isPreinspectionOn
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
            return .cancel(id: TimerID())
            
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
            let newResult = Result(time: state.time,
                                   scramble: state.scramble,
                                   date: .init())
            state.cubingState = .idle
            state.scramble = ScrambleProvider.newScramble(for: state.cube)
            let safeCheck = state.cube.safeCheckTime
            
            return .run { @MainActor send in
                if newResult.time < safeCheck {
                    send(.showSafeCheckPopup(newResult))
                } else {
                    send(.saveResult(newResult))
                }
            }
            
        case (_, .updateTime(let newTime)):
            state.time = newTime
            return .none
            
        case (_, .showSafeCheckPopup(let suspiciousResult)):
            state.alert = AlertState(
                title: TextState("Nice solve! ... or is it?"),
                message: TextState("If there is no issue then congratulations, impressive solve! But looking at world records, this might've been miss click - if this is the case, you can decide not to save this solve now."),
                primaryButton: .destructive(
                    TextState("Remove"),
                    action: .send(.dismissPopup)
                ),
                secondaryButton: .cancel(
                    TextState("Save"),
                    action: .send(.saveResult(suspiciousResult))
                )
            )
            return .none
            
        case (_, .dismissPopup):
            state.alert = nil
            return .none
            
        case (_, .saveResult(let result)):
            let saveAndCheckPb = Task(
                priority: environment.overlayCheckPriority
            ) {
                environment
                    .sessionsManager
                    .saveResultAndCheckForPb(result)
            }
            
            return .run { @MainActor send in
                let record = await saveAndCheckPb.value
                send(
                    .newRecordSet(record)
                )
            }
            
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

private extension Cube {
    var safeCheckTime: TimeInterval {
        switch self {
        case .two:
            return 0.20
        case .three:
            return 4.0
        case .four:
            return 10.0
        case .five:
            return 10.0
        }
    }
}
