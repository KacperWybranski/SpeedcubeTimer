//
//  SpeedcubeTimerApp.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/03/2022.
//

import SwiftUI
import ComposableArchitecture

@main
struct SpeedcubeTimerApp: App {
    var body: some Scene {
        WindowGroup {
            if NSClassFromString("XCTestCase") == nil {
                MainView(
                    store: Store(
                        initialState: MainFeature.State(),
                        reducer: MainFeature(sessionsManager: SessionsManager(), userSettings: UserSettings())
                    )
                )
                .preferredColorScheme(.dark)
            } else {
                Text("Running unit tests")
            }
        }
    }
}
