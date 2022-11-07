//
//  SpeedcubeTimerApp.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/03/2022.
//

import SwiftUI
import ComposableArchitecture

struct Middlewares { }
 
@main
struct SpeedcubeTimerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(
                store: Store(
                    initialState: MainFeature.State(),
                    reducer: MainFeature.reducer,
                    environment: .init(
                        sessionsManager: SessionsManager(),
                        userSettings: UserSettings()
                    )
                )
            )
            .preferredColorScheme(.dark)
        }
    }
}
