//
//  MainViewStateReducer.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 28/08/2022.
//

import Foundation

extension MainViewState {
    static let reducer: Reducer<Self> = { state, action in
        
        if let action = action as? MainViewStateAction {
            switch action {
            case .showOverlay:
                return MainViewState(isPresentingOverlay: true)
            case .hideOverlay:
                return MainViewState(isPresentingOverlay: false)
            }
        }
        
        return state
    }
}
