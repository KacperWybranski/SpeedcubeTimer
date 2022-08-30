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
            case .showOverlay(let text):
                return MainViewState(isPresentingOverlay: true,
                                     overlayText: text)
            case .hideOverlay:
                return MainViewState(isPresentingOverlay: false,
                                     overlayText: .empty)
            }
        }
        
        return state
    }
}
