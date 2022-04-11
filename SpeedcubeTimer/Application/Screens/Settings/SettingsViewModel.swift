//
//  SettingsViewModel.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 30/03/2022.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var appState: AppState
    @Published var currentCube: Cube {
        didSet {
            changeCurrentSession()
        }
    }
    @Published var currentSessionIndex: Int {
        didSet {
            changeCurrentSession()
        }
    }
    
    let allCubeOptions = Cube.allCases
    let allSessionOptions: [Int] = Array(1...10)
    
    init(appState: AppState) {
        self.appState = appState
        currentCube = appState.currentSession.cube
        currentSessionIndex = appState.currentSession.sessionindex
    }
    
    private func changeCurrentSession() {
        appState.changeSessionTo(cube: currentCube, index: currentSessionIndex)
    }
}
