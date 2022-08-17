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
            case .newSessionSet(let newSession):
                return ResultsViewState(currentSession: newSession)
            }
        }
        
        return state
    }
}

