//
//  TimerViewStateReducer.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 29/04/2022.
//

import Foundation

extension TimerViewState {
    static let reducer: Reducer<Self> = { state, action in
        
        if let settingsAction = action as? SettingsViewStateAction {
            switch settingsAction {
            case .cubeChanged(let newCube):
                return TimerViewState(cubingState: state.cubingState,
                                      time: state.time,
                                      cube: newCube,
                                      scramble: ScrambleProvider.newScramble(for: newCube),
                                      isPreinspectionOn: state.isPreinspectionOn)
            case .sessionChanged(let newSession):
                return state
                #warning("no change for now")
            case .isPreinspectionOnChanged(let isOn):
                return TimerViewState(cubingState: state.cubingState,
                                      time: state.time,
                                      cube: state.cube,
                                      scramble: state.scramble,
                                      isPreinspectionOn: isOn)
            }
        }
        
        switch (state.cubingState, action) {
        
        case (.idle, TimerViewStateAction.touchBegan):
            return TimerViewState(cubingState: .ready,
                                  time: .zero,
                                  cube: state.cube,
                                  scramble: state.scramble,
                                  isPreinspectionOn: state.isPreinspectionOn)
        case (.ready, TimerViewStateAction.touchEnded):
            return TimerViewState(cubingState: state.isPreinspectionOn ? .preinspectionOngoing : .ongoing,
                                  time: state.time,
                                  cube: state.cube,
                                  scramble: state.scramble,
                                  isPreinspectionOn: state.isPreinspectionOn)
        case (.ongoing, TimerViewStateAction.touchBegan):
            return TimerViewState(cubingState: .ended,
                                  time: state.time,
                                  cube: state.cube,
                                  scramble: state.scramble,
                                  isPreinspectionOn: state.isPreinspectionOn)
        case (.preinspectionOngoing, TimerViewStateAction.touchBegan):
            return TimerViewState(cubingState: .preinspectionReady,
                                  time: state.time,
                                  cube: state.cube,
                                  scramble: state.scramble,
                                  isPreinspectionOn: state.isPreinspectionOn)
        case (.preinspectionReady, TimerViewStateAction.touchEnded):
            return TimerViewState(cubingState: .ongoing,
                                  time: state.time,
                                  cube: state.cube,
                                  scramble: state.scramble,
                                  isPreinspectionOn: state.isPreinspectionOn)
        case (.ended, TimerViewStateAction.touchEnded):
            return TimerViewState(cubingState: .idle,
                                  time: state.time,
                                  cube: state.cube,
                                  scramble: ScrambleProvider.newScramble(for: state.cube),
                                  isPreinspectionOn: state.isPreinspectionOn)
        case (_, TimerViewStateAction.updateTime(let newTime)):
            return TimerViewState(cubingState: state.cubingState,
                                  time: newTime,
                                  cube: state.cube,
                                  scramble: state.scramble,
                                  isPreinspectionOn: state.isPreinspectionOn)
        default:
            return state
        }
    }
}
