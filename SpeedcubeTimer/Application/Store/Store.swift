//
//  Store.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 26/04/2022.
//

import Foundation
import SwiftUI
import Combine

enum Middlewares {}

protocol Action {}
typealias Reducer<State> = (State, Action) -> State
typealias Middleware<State> = (State, Action) -> AnyPublisher<Action, Never>

final class Store<State: Equatable>: ObservableObject {
    
    @Published private(set) var state: State
    
    private var subscriptions: [UUID: AnyCancellable] = [:]
    
    private let queue = DispatchQueue(label: "pl.speedcubeTimer.store", qos: .userInteractive)
    private let reducer: Reducer<State>
    private let middlewares: [Middleware<State>]
    
    init(initial state: State,
         reducer: @escaping Reducer<State>,
         middlewares: [Middleware<State>]) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
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
        
        middlewares
            .forEach { middleware in
                let key = UUID()
                middleware(newState, action)
                    .receive(on: RunLoop.main)
                    .sink(receiveCompletion: { [weak self] _ in
                        self?.subscriptions.removeValue(forKey: key)
                    }, receiveValue: { [weak self] action in
                        self?.dispatch(action)
                    })
                    .store(in: &subscriptions, key: key)
            }
        
        withAnimation {
            self.state = newState
        }
    }
}

extension AnyCancellable {
    func store(in dictionary: inout [UUID: AnyCancellable], key: UUID) {
        dictionary[key] = self
    }
}
