//
//  SpeedcubeTimerApp.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/03/2022.
//

import SwiftUI
 
@main
struct SpeedcubeTimerApp: App {
    private let store = Store(initial: AppState(),
                              reducer: AppState.reducer,
                              middlewares: [Middlewares.overlayCheck,
                                            Middlewares.sessionsUpdate,
                                            Middlewares.coreDataManager])
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.dark)
                .environmentObject(store)
        }
    }
}
