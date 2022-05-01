//
//  AppState.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 11/04/2022.
//

import SwiftUI

// MARK: - New Redux AppState

#warning("change name to AppState after old is removed")
struct ReduxAppState: Codable {
    let screens: [AppScreenState]
}

extension ReduxAppState {
    init() {
        screens = [.timerScreen(TimerViewState())]
    }
}

extension ReduxAppState: Equatable {
    static func == (lhs: ReduxAppState, rhs: ReduxAppState) -> Bool {
        lhs.screens == rhs.screens
    }
}

extension ReduxAppState {
    static let reducer: Reducer<Self> = { state, action in
        let screens = state.screens.map {
            AppScreenState.reducer($0, action)
        }
        return ReduxAppState(screens: screens)
    }
}

extension ReduxAppState {
    func screenState<State>(for screen: AppScreen) -> State? {
            return screens
                .compactMap {
                    switch ($0, screen) {
                    case (.timerScreen(let state), .timer):
                        return state as? State
                    }
                }
                .first
        }
    
    enum AppScreen {
        case timer
    }
}

// MARK: - Old MVVM AppState

class AppState: ObservableObject {
    private var allSessions: [CubingSession]
    
    @Published var currentSession: CubingSession = .initialSession
    @Published var isPreinspectionOn: Bool = false
    
    init(sessions: [CubingSession]) {
        allSessions = sessions
        
        if let first = sessions.first {
            currentSession = first
        } else {
            setNewSession(cube: .three, index: 1)
        }
    }
    
    private func setNewSession(cube: Cube, index: Int) {
        let newSession = CubingSession(results: [], cube: cube, index: index)
        allSessions.append(newSession)
        currentSession = newSession
    }
    
    func changeSessionTo(cube: Cube, index: Int) {
        if let session = allSessions.first(where: { $0.cube == cube && $0.index == index }) {
            currentSession = session
        } else {
            setNewSession(cube: cube, index: index)
        }
    }
    
    func addNewResult(_ result: Result) {
        currentSession.results.insert(result, at: 0)
    }
    
    func remove(at offsets: IndexSet) {
        currentSession.results.remove(atOffsets: offsets)
    }
    
    func averageOfLast(_ solvesCount: Int) -> TimeInterval? {
        guard currentSession.results.count >= solvesCount else { return nil }
        
        var times = currentSession.results
            .prefix(solvesCount)
            .map { $0.time }
            .sorted()
        times.removeLast()
        times.removeFirst()
        
        return times.average
    }
    
    func meanOfLast(_ solvesCount: Int) -> TimeInterval? {
        guard currentSession.results.count >= solvesCount else { return nil }
        
        return currentSession.results
            .prefix(solvesCount)
            .map { $0.time }
            .sorted()
            .average
    }
}

