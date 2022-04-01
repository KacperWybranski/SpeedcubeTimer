//
//  MainViewModel.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 29/03/2022.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published private(set) var settings: AppSettings
    @Published private(set) var timerViewModel: TimerViewModel
    @Published private(set) var resultsListViewModel: ResultsListViewModel
    @Published private(set) var settingsViewModel: SettingsViewModel
    
    init() {
        let initialSettings = AppSettings(sessions: [.initialSession]) // load from userdefaults maybe?
        settings = initialSettings
        timerViewModel = .init(settings: initialSettings)
        resultsListViewModel = .init(settings: initialSettings)
        settingsViewModel = .init(settings: initialSettings)
    }
    
    func setSessionTo(cube: Cube, index: Int) {
        settings.changeSessionTo(cube: cube, index: index)
    }
}
