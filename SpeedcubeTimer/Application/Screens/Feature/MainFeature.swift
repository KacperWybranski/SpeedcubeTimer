//
//  MainViewFeature.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 12/10/2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct MainFeature {
    
    // MARK: - State
    
    struct State: Equatable {
        var isPresentingOverlay: Bool = false
        var overlayText: String = .empty
        var tabSelection: Int = 1
        
        var settings: SettingsFeature.State = .init()
        var resultsList: ResultsListFeature.State = .init()
        var timer: TimerFeature.State = .init()
    }
    
    // MARK: - Action
    
    enum Action {
        case selectionChanged(_ selection: Int)
        case showOverlay(text: String)
        case hideOverlay
        
        case settings(SettingsFeature.Action)
        case resultsList(ResultsListFeature.Action)
        case timer(TimerFeature.Action)
    }
    
    // MARK: - Environment
    
    struct Environment {
        let sessionsManager: SessionsManaging
    }
    
    // MARK: - Reducer
    
    static let reducer = Reducer<State, Action, Environment>
        .combine(
            SettingsFeature
                    .reducer
                    .pullback(
                        state: \State.settings,
                        action: /Action.settings,
                        environment: { environment in
                            .init(sessionsManager: environment.sessionsManager)
                        }
                    ),
            ResultsListFeature
                    .reducer
                    .pullback(
                        state: \State.resultsList,
                        action: /Action.resultsList,
                        environment: { environment in
                            .init(sessionsManager: environment.sessionsManager)
                        }
                    ),
            TimerFeature
                    .reducer
                    .pullback(
                        state: \State.timer,
                        action: /Action.timer,
                        environment: { environment in
                            .init(mainQueue: .main, sessionsManager: environment.sessionsManager)
                        }
                    ),
            Reducer<State, Action, Environment> { state, action, environment in
                switch action {
                case .selectionChanged(let selection):
                    state.tabSelection = selection
                    return .none
                    
                case .showOverlay(let text):
                    state.isPresentingOverlay = true
                    state.overlayText = text
                    return .none
                    
                case .hideOverlay:
                    state.isPresentingOverlay = false
                    state.overlayText = .empty
                    return .none
                case .settings(.cubeChanged(let cube)):
                    
                    return .none
                default:
                    return .none
                }
            }
        )
}
