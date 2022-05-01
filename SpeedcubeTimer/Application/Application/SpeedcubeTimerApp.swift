//
//  SpeedcubeTimerApp.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/03/2022.
//

import SwiftUI
 
@main
struct SpeedcubeTimerApp: App {
    let store = Store(initial: ReduxAppState(), reducer: ReduxAppState.reducer)
    
    var body: some Scene {
        WindowGroup {
            TimerView()
                .preferredColorScheme(.dark)
                .environmentObject(store)
        }
    }
}
