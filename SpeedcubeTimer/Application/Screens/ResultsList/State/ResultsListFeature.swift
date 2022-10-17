//
//  ResultsListViewFeature.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 17/10/2022.
//

import Foundation
import ComposableArchitecture

struct ResultsListFeature: ReducerProtocol {
    
    // MARK: - State
    
    struct State: Equatable {
        var currentSession: CubingSession
        
        var currentAvg5: AverageResult? {
            currentSession.avgOfLast(5)
        }
        var currentAvg12: AverageResult? {
            currentSession.avgOfLast(12)
        }
        var currentMean100: AverageResult? {
            currentSession.meanOfLast(100)
        }
        
        var bestResult: Result? {
            currentSession.bestResult
        }
        
        var bestAvg5: AverageResult? {
            currentSession.bestAvgOf(5, mode: .avgOf)
        }
        
        var bestAvg12: AverageResult? {
            currentSession.bestAvgOf(12, mode: .avgOf)
        }
        
        var bestMean100: AverageResult? {
            currentSession.bestAvgOf(100, mode: .meanOf)
        }
    }
    
    // MARK: - Action
    
    enum Action {
        case removeResultsAt(_ offsets: IndexSet)
    }
    
    // MARK: - Reducer
    
    func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
//        case .newSessionSet(let current):
//            state.currentSession = current
        case .removeResultsAt(let offsets):
            return .none
            // return .removeResults ...
        }
    }
}
