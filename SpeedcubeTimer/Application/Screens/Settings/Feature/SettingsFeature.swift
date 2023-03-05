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
        var alert: AlertState<Action>?
        
        @BindingState var isPreinspectionOn: Bool = false
        @BindingState var selectedCube: Cube = .three
        @BindingState var selectedIndex: Int = 1
        @BindingState var sessionName: String = .empty
        
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
    
    enum Action: BindableAction, Equatable {
        case loadSessions
        case sessionsLoaded(allSesions: [CubingSession], currentSession: CubingSession)
        case eraseCurrentSession
        case showResetPopup
        case showEraseSessionPopup
        case resetApp
        case dismissPopup
        case binding(BindingAction<State>)
    }
    
    // MARK: - Environment
    
    struct Environment {
        let sessionsManager: SessionsManaging
        let userSettings: UserSettingsProtocol
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
            state.sessionName = newCurrent.name ?? .empty
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
        
        case .binding(\.$isPreinspectionOn):
            environment
                .userSettings
                .setIsPreinspectionOn(
                    state.isPreinspectionOn
                )
            
            return .none
            
        case .binding(\.$selectedCube):
            environment
                .sessionsManager
                .setCurrentSession(
                    environment
                        .sessionsManager
                        .session(for: state.selectedCube)
                )
            return .run { @MainActor send in
                send(.loadSessions)
            }
            
        case .binding(\.$selectedIndex):
            environment
                .sessionsManager
                .setCurrentSession(
                    environment
                        .sessionsManager
                        .sessionForCurrentCube(and: state.selectedIndex)
                )
            return .run { @MainActor send in
                send(.loadSessions)
            }
        
        case .binding(\.$sessionName):
            environment
                .sessionsManager
                .setNameForCurrentSession(state.sessionName)
            return .run { @MainActor send in
                send(.loadSessions)
            }
            
        case .binding:
            return .none
        }
    }
    .binding()
}
