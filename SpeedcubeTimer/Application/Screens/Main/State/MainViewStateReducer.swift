//
//  MainViewStateReducer.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 28/08/2022.
//

import Foundation

extension MainViewState {
    static let reducer: Reducer<Self> = { state, action in
        
        switch action {
        case MainViewStateAction.selectionChanged(let selection):
            return MainViewState(isPresentingOverlay: state.isPresentingOverlay,
                                 overlayText: state.overlayText,
                                 tabSelection: selection)
        case MainViewStateAction.showOverlay(let text):
            return MainViewState(isPresentingOverlay: true,
                                 overlayText: text,
                                 tabSelection: state.tabSelection)
        case MainViewStateAction.hideOverlay:
            return MainViewState(isPresentingOverlay: false,
                                 overlayText: .empty,
                                 tabSelection: state.tabSelection)
        default:
            return state
        }
    }
}
