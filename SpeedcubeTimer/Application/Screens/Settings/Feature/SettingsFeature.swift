//
//  SettingsViewFeature.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 12/10/2022.
//

import Foundation
import ComposableArchitecture

struct SettingsFeature {
    
    // MARK: - State
    
    struct State: Equatable {
        var allSessions: [CubingSession] = []
        var currentSession: CubingSession = .init()
        var isPreinspectionOn: Bool = false
        var isPresentingEraseSessionPopup: Bool = false
        var isPresentingResetActionSheet: Bool = false
        var isPresentingResetAppPopup: Bool = false
        
        static let availableCubes: [Cube] = Cube.allCases
        static let availableSessionNums: [Int] = Array(1...10)
        
        func identifierForSession(with index: Int) -> String? {
            allSessions
                .filter { $0.cube == currentSession.cube && $0.index == index }
                .first?
                .name
        }
    }
    
    // MARK: - Action
    
    enum Action {
        case loadSessions
        case sessionsLoaded(allSesions: [CubingSession], currentSession: CubingSession)
        case currentSessionNameChanged(_ name: String)
        case cubeChanged(_ cube: Cube)
        case sessionIndexChanged(_ session: Int)
        case isPreinspectionOnChanged(_ isOn: Bool)
        case eraseSession(_ session: CubingSession)
        case showResetActionSheet(_ show: Bool)
        case showEraseSessionPopup(_ show: Bool)
        case showResetAppPopup(_ show: Bool)
        case resetApp
    }
    
    // MARK: - Environment
    
    struct Environment {
        let sessionsManager: SessionsManaging
    }
    
    // MARK: - Reducer
    
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .loadSessions:
            return .run { @MainActor send in
                let currentSession = environment.sessionsManager.currentSession
                let allSessions = environment.sessionsManager.allSessions
                send(
                    .sessionsLoaded(allSesions: allSessions, currentSession: currentSession)
                )
            }
            
        case .sessionsLoaded(let newAll, let newCurrent):
            state.allSessions = newAll
            state.currentSession = newCurrent
            return .none
            
        case .isPreinspectionOnChanged(let isPreinspectionOn):
            state.isPreinspectionOn = isPreinspectionOn
            return .none
            
        case .showEraseSessionPopup(let show):
            state.isPresentingEraseSessionPopup = show
            return .none
            
        case .showResetActionSheet(let show):
            state.isPresentingResetActionSheet = show
            return .none
            
        case .showResetAppPopup(let show):
            state.isPresentingResetAppPopup = show
            return .none
            
        case .cubeChanged(let cube):
            environment
                .sessionsManager
                .setCurrentSession(
                    environment
                        .sessionsManager
                        .session(for: cube)
                )
            return .run { @MainActor send in
                send(.loadSessions)
            }
        case .sessionIndexChanged(let index):
            environment
                .sessionsManager
                .setCurrentSession(
                    environment
                        .sessionsManager
                        .sessionForCurrentCube(and: index)
                )
            return .run { @MainActor send in
                send(.loadSessions)
            }
            
        case .currentSessionNameChanged(let name):
            environment
                .sessionsManager
                .setNameForCurrentSession(name)
            return .run { @MainActor send in
                send(.loadSessions)
            }
          
        case .resetApp:
            return .none
            // return .resetApp ...
            
        case .eraseSession(let session):
            return .none
            // return .eraseSession
            
        }
    }
}
