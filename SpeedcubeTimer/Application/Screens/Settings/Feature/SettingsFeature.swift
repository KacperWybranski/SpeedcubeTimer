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
        var alert: AlertState<Action>?
        
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
    
    enum Action: Equatable {
        case loadSessions
        case sessionsLoaded(allSesions: [CubingSession], currentSession: CubingSession)
        case currentSessionNameChanged(_ name: String)
        case cubeChanged(_ cube: Cube)
        case sessionIndexChanged(_ session: Int)
        case isPreinspectionOnChanged(_ isOn: Bool)
        case eraseCurrentSession
        case showResetPopup
        case showEraseSessionPopup
        case resetApp
        case dismissPopup
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
                let loadedSessions = environment
                                            .sessionsManager
                                            .loadSessions()
                send(
                    .sessionsLoaded(
                        allSesions: loadedSessions.all,
                        currentSession: loadedSessions.current
                    )
                )
            }
            
        case .sessionsLoaded(let newAll, let newCurrent):
            state.allSessions = newAll
            state.currentSession = newCurrent
            return .none
            
        case .isPreinspectionOnChanged(let isPreinspectionOn):
            state.isPreinspectionOn = isPreinspectionOn
            return .none
            
        case .showEraseSessionPopup:
            state.alert = AlertState(
                title: TextState("Erase current session?"),
                message: TextState("Current session name and all results from this session will be removed."),
                primaryButton: .destructive(
                    TextState("Yes"),
                    action: .send(.eraseCurrentSession)
                ),
                secondaryButton: .cancel(
                    TextState("No"),
                    action: .send(.dismissPopup)
                )
            )
            return .none
            
        case .showResetPopup:
            state.alert = AlertState(
                title: TextState("Reset app data?"),
                message: TextState("All data including results in every session will be removed. This action cannot be undone."),
                primaryButton: .destructive(
                    TextState("Yes"),
                    action: .send(.resetApp)
                ),
                secondaryButton: .cancel(
                    TextState("Cancel"),
                    action: .send(.dismissPopup)
                )
            )
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
            environment
                .sessionsManager
                .resetApp()
            return .run { @MainActor send in
                send(.loadSessions)
            }
            
        case .eraseCurrentSession:
            environment
                .sessionsManager
                .erase(
                    session: state.currentSession
                )
            return .run { @MainActor send in
                send(.loadSessions)
            }
            
        case .dismissPopup:
            state.alert = nil
            
            return .none
        }
    }
}
