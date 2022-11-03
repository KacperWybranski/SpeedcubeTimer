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
        var tabSelection: Int = 1
        var isPresentingOverlay: Bool = false
        var overlayText: String = .empty
        
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
                            .init(sessionsManager: environment.sessionsManager, calculationsPriority: .medium)
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
                    
                case .timer(.newRecordSet(let type)):
                    var overlayText: String {
                        switch type {
                        case .single:
                            return "🤩 new best single 🥳"
                        case .avg5:
                            return "🤯 new best avg5 😱"
                        case .avg12:
                            return "🎉 new best avg12 🎉"
                        case .mo100:
                            return "🪑 new best mo100 👏"
                        }
                    }
                    return .run { @MainActor send in
                        send(
                            .showOverlay(text: overlayText)
                        )
                    }
                    
                case .showOverlay(let text):
                    state.isPresentingOverlay = true
                    state.overlayText = text
                    return .none
                    
                case .hideOverlay:
                    state.isPresentingOverlay = false
                    return .none
                    
                    
                default:
                    return .none
                }
            }
        )
}
