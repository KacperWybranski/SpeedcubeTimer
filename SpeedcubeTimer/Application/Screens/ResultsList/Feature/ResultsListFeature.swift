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
        
        fileprivate(set) var currentAvg5: AverageResult?
        
        fileprivate(set) var currentAvg12: AverageResult?
        
        fileprivate(set) var currentMean100: AverageResult?
        
        fileprivate(set) var bestResult: Result?
        
        fileprivate(set) var bestAvg5: AverageResult?
        
        fileprivate(set) var bestAvg12: AverageResult?
        
        fileprivate(set) var bestMean100: AverageResult?
    }
    
    // MARK: - Action
    
    enum Action {
        case loadSession
        case sessionLoaded(_ currentSession: CubingSession)
        case calculateResults(_ session: CubingSession)
        case resultsCalculated(_ state: State)
        case removeResultsAt(_ offsets: IndexSet)
    }
    
    // MARK: - Environment
    
    struct Environment {
        let sessionsManager: SessionsManaging
        let calculationsPriority: TaskPriority
    }
    
    // MARK: - Reducer
    
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .loadSession:
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
            
        case .sessionLoaded(let newCurrent):
            state.currentSession = newCurrent
            return .run { @MainActor send in
                send(.calculateResults(newCurrent))
            }
            
        case .calculateResults(let session):
            let calculation = Task(priority: environment.calculationsPriority) {
                return State(
                    currentSession: session,
                    currentAvg5: session.avgOfLast(5),
                    currentAvg12: session.avgOfLast(12),
                    currentMean100: session.meanOfLast(100),
                    bestResult: session.bestResult,
                    bestAvg5: session.bestAvgOf(5, mode: .avgOf),
                    bestAvg12: session.bestAvgOf(12, mode: .avgOf),
                    bestMean100: session.bestAvgOf(100, mode: .meanOf)
                )
            }
            return .run { @MainActor send in
                let calculated = await calculation.value
                send(
                    .resultsCalculated(calculated)
                )
            }
            
            
        case .resultsCalculated(let calculatedState):
            state = calculatedState
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
