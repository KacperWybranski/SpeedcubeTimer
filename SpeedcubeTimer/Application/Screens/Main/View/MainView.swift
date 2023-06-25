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
            TabViewOrHorizontalTabView(
                selection: viewStore
                    .binding(
                        get: { $0.tabSelection },
                        send: { .selectionChanged($0) }
                    ),
                rows: [
                    TabViewOrHorizontalTabViewRow {
                        ResultsListView(
                            store: self.store
                                .scope(
                                    state: \.resultsList,
                                    action: MainFeature.Action.resultsList
                                )
                        )
                    } label: {
                        Label("Results", systemImage: "list.number")
                    },
                    
                    TabViewOrHorizontalTabViewRow {
                        TimerView(
                            store: self.store
                                .scope(
                                    state: \.timer,
                                    action: MainFeature.Action.timer
                                )
                        )
                    } label: {
                        Label("Timer", systemImage: "timer")
                    },
                    
                    TabViewOrHorizontalTabViewRow {
                        SettingsView(
                            store: self.store
                                .scope(
                                    state: \.settings,
                                    action: MainFeature.Action.settings
                                )
                        )
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                ]
            )
            .accentColor(.primaryTheme)
            .onAppear {
                if #available(iOS 15.0, *) {
                    let appearance = UITabBarAppearance()
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
            }
            .recordOverlay(
                text: viewStore.overlayText,
                .init(get: { viewStore.isPresentingOverlay },
                      set: { if !$0 { viewStore.send(.hideOverlay) } })
            )
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
