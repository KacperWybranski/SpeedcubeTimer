//
//  SettingsViewFeature.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 12/10/2022.
//

import Foundation
import ComposableArchitecture

struct SettingsFeature: ReducerProtocol {
    
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
    
    // MARK: - Reducer
    
    func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        
        switch action {
//        case AppStateAction.newSessionsSet(_, let newCurrent, let newAllSessions):
//            state.allSessions = newAllSessions
//            state.currentSession = newCurrent
//            return SettingsViewState(allSessions: newAllSessions,
//                                     currentSession: newCurrent,
//                                     isPreinspectionOn: state.isPreinspectionOn,
//                                     isPresentingEraseSessionPopup: state.isPresentingEraseSessionPopup,
//                                     isPresentingResetActionSheet: state.isPresentingResetActionSheet,
//                                     isPresentingResetAppPopup: state.isPresentingResetAppPopup)
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
            return .none
            //return .cubeChange ...
        case .currentSessionNameChanged(let name):
            return .none
            //return .nameChange ...
        case .resetApp:
            return .none
            // return .resetApp ...
        case .sessionIndexChanged(_):
            return .none
            // return .sessionIndexChange ...
        case .eraseSession(let session):
            return .none
            // return .eraseSession
        }
    }
}
