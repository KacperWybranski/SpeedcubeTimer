//
//  MainViewModel.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 29/03/2022.
//

import Combine

class MainViewModel: ObservableObject {
    @Published private(set) var appState: AppState
    @Published private(set) var timerViewModel: TimerViewModel
    @Published private(set) var resultsListViewModel: ResultsListViewModel
    @Published private(set) var settingsViewModel: SettingsViewModel
    
    init() {
        let initialAppState = AppState(sessions: [.initialSession]) // load from userdefaults maybe?
        appState = initialAppState
        timerViewModel = .init(appState: initialAppState)
        resultsListViewModel = .init(appState: initialAppState)
        settingsViewModel = .init(appState: initialAppState)
    }
    
    func setSessionTo(cube: Cube, index: Int) {
        appState.changeSessionTo(cube: cube, index: index)
    }
}
