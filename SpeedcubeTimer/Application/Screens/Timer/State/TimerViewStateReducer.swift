//
//  TimerViewStateReducer.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 29/04/2022.
//

import Foundation

extension TimerViewState {
    static let reducer: Reducer<Self> = { state, action in
        
        if let action = action as? AppStateAction {
            switch action {
            case .newSessionSet(let newSession):
                return TimerViewState(cubingState: state.cubingState,
                                      time: state.time,
                                      cube: newSession.cube,
                                      scramble: ScrambleProvider.newScramble(for: newSession.cube),
                                      isPreinspectionOn: state.isPreinspectionOn,
                                      isPresentingOverlay: state.isPresentingOverlay)
            }
        }
        
        if let settingsAction = action as? SettingsViewStateAction {
            switch settingsAction {
            case .isPreinspectionOnChanged(let isOn):
                return TimerViewState(cubingState: state.cubingState,
                                      time: state.time,
                                      cube: state.cube,
                                      scramble: state.scramble,
                                      isPreinspectionOn: isOn,
                                      isPresentingOverlay: state.isPresentingOverlay)
            default:
                break
            }
        }
        
        switch (state.cubingState, action) {
        
        case (.idle, TimerViewStateAction.touchBegan):
            return TimerViewState(cubingState: .ready,
                                  time: .zero,
                                  cube: state.cube,
                                  scramble: state.scramble,
                                  isPreinspectionOn: state.isPreinspectionOn,
                                  isPresentingOverlay: state.isPresentingOverlay)
        case (.ready, TimerViewStateAction.touchEnded):
            return TimerViewState(cubingState: state.isPreinspectionOn ? .preinspectionOngoing : .ongoing,
                                  time: state.time,
                                  cube: state.cube,
                                  scramble: state.scramble,
                                  isPreinspectionOn: state.isPreinspectionOn,
                                  isPresentingOverlay: state.isPresentingOverlay)
        case (.ongoing, TimerViewStateAction.touchBegan):
            return TimerViewState(cubingState: .ended,
                                  time: state.time,
                                  cube: state.cube,
                                  scramble: state.scramble,
                                  isPreinspectionOn: state.isPreinspectionOn,
                                  isPresentingOverlay: state.isPresentingOverlay)
        case (.preinspectionOngoing, TimerViewStateAction.touchBegan):
            return TimerViewState(cubingState: .preinspectionReady,
                                  time: state.time,
                                  cube: state.cube,
                                  scramble: state.scramble,
                                  isPreinspectionOn: state.isPreinspectionOn,
                                  isPresentingOverlay: state.isPresentingOverlay)
        case (.preinspectionReady, TimerViewStateAction.touchEnded):
            return TimerViewState(cubingState: .ongoing,
                                  time: state.time,
                                  cube: state.cube,
                                  scramble: state.scramble,
                                  isPreinspectionOn: state.isPreinspectionOn,
                                  isPresentingOverlay: state.isPresentingOverlay)
        case (.ended, TimerViewStateAction.touchEnded):
            return TimerViewState(cubingState: .idle,
                                  time: state.time,
                                  cube: state.cube,
                                  scramble: ScrambleProvider.newScramble(for: state.cube),
                                  isPreinspectionOn: state.isPreinspectionOn,
                                  isPresentingOverlay: state.isPresentingOverlay)
        case (_, TimerViewStateAction.updateTime(let newTime)):
            return TimerViewState(cubingState: state.cubingState,
                                  time: newTime,
                                  cube: state.cube,
                                  scramble: state.scramble,
                                  isPreinspectionOn: state.isPreinspectionOn,
                                  isPresentingOverlay: state.isPresentingOverlay)
        case (_, TimerViewStateAction.showOverlay):
            return TimerViewState(cubingState: state.cubingState,
                                  time: state.time,
                                  cube: state.cube,
                                  scramble: state.scramble,
                                  isPreinspectionOn: state.isPreinspectionOn,
                                  isPresentingOverlay: true)
        case (_, TimerViewStateAction.hideOverlay):
            return TimerViewState(cubingState: state.cubingState,
                                  time: state.time,
                                  cube: state.cube,
                                  scramble: state.scramble,
                                  isPreinspectionOn: state.isPreinspectionOn,
                                  isPresentingOverlay: false)
        default:
            return state
        }
    }
}
