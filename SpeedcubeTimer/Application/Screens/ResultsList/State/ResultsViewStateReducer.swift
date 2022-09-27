//
//  ResultsViewStateReducer.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 16/05/2022.
//

import Foundation

extension ResultsViewState {
    static let reducer: Reducer<Self> = { state, action in
        
        if let action = action as? AppStateAction {
            switch action {
            case .newSessionsSet(_, let newSession, _):
                return ResultsViewState(currentSession: newSession)
            default:
                break
            }
        }
        
        return state
    }
}

