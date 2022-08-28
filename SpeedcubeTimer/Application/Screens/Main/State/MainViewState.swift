//
//  MainViewState.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 28/08/2022.
//

import Foundation

struct MainViewState: Equatable {
    let isPresentingOverlay: Bool
}

extension MainViewState {
    init() {
        isPresentingOverlay = false
    }
}
