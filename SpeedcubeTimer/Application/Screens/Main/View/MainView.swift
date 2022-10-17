//
//  MainView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 24/03/2022.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    let store: StoreOf<MainFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                TabView(
                    selection: viewStore
                                    .binding(
                                        get: { $0.tabSelection },
                                        send: { .selectionChanged($0) }
                                    )
                ) {
                    ResultsListView()
                        .tabItem {
                            Label("Results", systemImage: "list.number")
                        }
                        .tag(0)
                    TimerView()
                        .tabItem {
                            Label("Timer", systemImage: "timer")
                        }
                        .tag(1)
                    SettingsView()
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
                    
                    viewStore.send(.loadSessions)
                }
                
                if viewStore.isPresentingOverlay {
                    OverlayAnimationView(text: viewStore.overlayText) {
                        viewStore.send(.hideOverlay)
                    }
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
                reducer: MainFeature())
        )
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 13 mini")
    }
}
