//
//  MainViewFeature.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 12/10/2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct MainFeature: ReducerProtocol {
    
    // MARK: - State
    
    struct State: Equatable {
        var tabSelection: Int = 1
        
        var settings: SettingsFeature.State = .init()
        var resultsList: ResultsListFeature.State = .init()
        var timer: TimerFeature.State = .init()
    }
    
    // MARK: - Action
    
    enum Action {
        case selectionChanged(_ selection: Int)
        
        case settings(SettingsFeature.Action)
        case resultsList(ResultsListFeature.Action)
        case timer(TimerFeature.Action)
    }
    
    // MARK: - Dependencies
    
    let sessionsManager: SessionsManaging
    let userSettings: UserSettingsProtocol
    
    // MARK: - Reducer
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state , action in
            switch action {
            case .selectionChanged(let selection):
                state.tabSelection = selection
                return .none
            default:
                return .none
            }
        }
        Scope(state: \.settings, action: /Action.settings) {
            SettingsFeature(sessionsManager: sessionsManager, userSettings: userSettings)
        }
        Scope(state: \.resultsList, action: /Action.resultsList) {
            ResultsListFeature(sessionsManager: sessionsManager, calculationsPriority: .medium)
        }
        Scope(state: \.timer, action: /Action.timer) {
            TimerFeature(
                mainQueue: .main,
                overlayCheckPriority: .medium,
                sessionsManager: sessionsManager,
                userSettings: userSettings
            )
        }
    }
}
