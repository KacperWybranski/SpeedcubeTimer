//
//  SpeedcubeTimerApp.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/03/2022.
//

import SwiftUI

@main
struct SpeedcubeTimerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel())
                .preferredColorScheme(.dark)
        }
    }
}
