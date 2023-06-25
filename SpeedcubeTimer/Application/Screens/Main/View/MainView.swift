//
//  MainView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 24/03/2022.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    let store: Store<MainFeature.State, MainFeature.Action>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            TabView(
                selection: viewStore
                    .binding(
                        get: \.tabSelection,
                        send: MainFeature.Action.selectionChanged
                    )
            ) {
                ResultsListView(
                    store: self.store
                        .scope(
                            state: \.resultsList,
                            action: MainFeature.Action.resultsList
                        )
                )
                .tabItem {
                    Label("Results", systemImage: "list.number")
                }
                .tag(0)
                
                TimerView(
                    store: self.store
                        .scope(
                            state: \.timer,
                            action: MainFeature.Action.timer
                        )
                )
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
                .tag(1)
                
                SettingsView(
                    store: self.store
                        .scope(
                            state: \.settings,
                            action: MainFeature.Action.settings
                        )
                )
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(2)
            }
            .accentColor(.primaryTheme)
            .onAppear {
                if #available(iOS 15.0, *) {
                    let appearance = UITabBarAppearance()
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            store: Store(
                initialState: MainFeature.State(),
                reducer: MainFeature(
                    sessionsManager: SessionsManager(),
                    userSettings: UserSettings()
                )
            )
        )
        .preferredColorScheme(.dark)
        .previewDevice("iPhone 13 mini")
    }
}
