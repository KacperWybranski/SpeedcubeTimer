//
//  ResultsViewStateReducer.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 16/05/2022.
//

import Foundation

extension ResultsViewState {
    static let reducer: Reducer<Self> = { state, action in
        
        if let action = action as? TimerViewStateAction {
            switch action {
            case .saveResult(let newResult):
                let oldSession = state.currentSession
                var newResults = oldSession.results
                newResults.insert(newResult, at: 0)
                return ResultsViewState(currentSession: .init(results: newResults,
                                                              cube: oldSession.cube,
                                                              index: oldSession.index,
                                                              id: oldSession.id))
            default:
                break
            }
        }
        
        if let action = action as? ResultsViewStateAction {
            switch action {
            case .removeResultsAt(let offsets):
                let oldSession = state.currentSession
                var newResults = oldSession.results
                newResults.remove(atOffsets: offsets)
                return ResultsViewState(currentSession: .init(results: newResults,
                                                              cube: oldSession.cube,
                                                              index: oldSession.index,
                                                              id: oldSession.id))
            }
        }
        
        return state
    }
}

