//
//  MainView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 24/03/2022.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var store: Store<ReduxAppState>
    @State private var selection: Int = 1
    
    var body: some View {
        TabView(selection: $selection) {
            TimerView()
                .tabItem {
                    Label("TImer", systemImage: "timer")
                }
                .tag(1)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(2)
        }
        .accentColor(.green)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Store(initial: ReduxAppState(), reducer: ReduxAppState.reducer))
    }
}
