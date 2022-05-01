//
//  TimerViewStateReducer.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 29/04/2022.
//

import Foundation

extension TimerViewState {
    static let reducer: Reducer<Self> = { state, action in
        
        switch (state.cubingState, action) {
        
        case (.idle, TimerViewStateAction.touchBegan):
            return TimerViewState(cubingState: .ready,
                                  time: .zero,
                                  cube: state.cube,
                                  scramble: state.scramble)
        case (.ready, TimerViewStateAction.touchEnded):
            return TimerViewState(cubingState: .ongoing,
                                  time: state.time,
                                  cube: state.cube,
                                  scramble: state.scramble)
        case (.ongoing, TimerViewStateAction.touchBegan):
            return TimerViewState(cubingState: .ended,
                                  time: state.time,
                                  cube: state.cube,
                                  scramble: state.scramble)
        case (.ended, TimerViewStateAction.touchEnded):
            return TimerViewState(cubingState: .idle,
                                  time: state.time,
                                  cube: state.cube,
                                  scramble: ScrambleProvider.newScramble(for: .three))
        case (.ongoing, TimerViewStateAction.updateTime(let newTime)):
            return TimerViewState(cubingState: state.cubingState,
                                  time: newTime,
                                  cube: state.cube,
                                  scramble: state.scramble)
        default:
            return state
        }
    }
}
