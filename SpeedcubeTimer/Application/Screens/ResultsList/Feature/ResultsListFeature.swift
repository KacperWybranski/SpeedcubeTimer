//
//  ResultsListViewFeature.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 17/10/2022.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct ResultsListFeature {
    
    // MARK: - State
    
    struct State: Equatable {
        var currentSession: CubingSession = .initialSession
        
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
        case loadSession
        case sessionLoaded(_ currentSession: CubingSession)
        case removeResultsAt(_ offsets: IndexSet)
    }
    
    // MARK: - Environment
    
    struct Environment {
        let sessionsManager: SessionsManaging
    }
    
    // MARK: - Reducer
    
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .loadSession:
            return .run { @MainActor send in
                send(
                    .sessionLoaded(environment.sessionsManager.currentSession)
                )
            }
            
        case .sessionLoaded(let newCurrent):
            state.currentSession = newCurrent
            return .none
            
        case .removeResultsAt(let offsets):
            environment
                .sessionsManager
                .removeResults(at: offsets)
            return .run { @MainActor send in
                send(.loadSession)
            }
        }
    }
}
