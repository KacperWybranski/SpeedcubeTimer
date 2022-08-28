//
//  Store.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 26/04/2022.
//

import Foundation
import SwiftUI

protocol Action {}

typealias Reducer<State> = (State, Action) -> State

final class Store<State: Equatable>: ObservableObject {
    
    @Published private(set) var state: State
    
    private let queue = DispatchQueue(label: "pl.speedcubeTimer.store", qos: .userInteractive)
    private let reducer: Reducer<State>
    
    init(initial state: State, reducer: @escaping Reducer<State>) {
        self.state = state
        self.reducer = reducer
    }
    
    func restoreState(_ state: State) {
        self.state = state
    }
    
    func dispatch(_ action: Action) {
        queue.sync {
            dispatch(self.state, action)
        }
    }
    
    private func dispatch(_ currentState: State, _ action: Action) {
        let newState = reducer(currentState, action)
        
        guard newState != currentState else { return }
        
        withAnimation {
            self.state = newState
        }
    }
}
