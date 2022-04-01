//
//  SettingsViewModel.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 30/03/2022.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var appSettings: AppSettings
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
    
    init(settings: AppSettings) {
        appSettings = settings
        currentCube = settings.currentSession.cube
        currentSessionIndex = settings.currentSession.sessionindex
    }
    
    private func changeCurrentSession() {
        appSettings.changeSessionTo(cube: currentCube, index: currentSessionIndex)
    }
}
