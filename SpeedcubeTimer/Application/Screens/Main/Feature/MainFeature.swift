//
//  MainViewFeature.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 12/10/2022.
//

import Foundation
import ComposableArchitecture

struct MainFeature: ReducerProtocol {
    
    // MARK: - State
    
    struct State: Equatable {
        var isPresentingOverlay: Bool = false
        var overlayText: String = .empty
        var tabSelection: Int = 1
    }
    
    // MARK: - Action
    
    enum Action: Equatable {
        case selectionChanged(_ selection: Int)
        case showOverlay(text: String)
        case hideOverlay
        case loadSessions
    }
    
    // MARK: - Reducer
    
    func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        
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
        case .loadSessions:
            return .none
            // return .loadSessions or something
        }
    }
}
