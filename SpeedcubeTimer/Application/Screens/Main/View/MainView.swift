//
//  MainView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 24/03/2022.
//

import SwiftUI


struct MainView: View {
    @EnvironmentObject var store: Store<AppState>
    
    var state: MainViewState { store.state.screenState(for: .main) ?? .init() }
    
    var body: some View {
        ZStack {
            TabViewOrHorizontalTabView(
                selection: Binding(get: { state.tabSelection },
                                   set: { store.dispatch(MainViewStateAction.selectionChanged($0)) }),
                rows: [
                    TabViewOrHorizontalTabViewRow {
                        ResultsListView()
                    } label: {
                        Label("Results", systemImage: "list.number")
                    },
                    
                    TabViewOrHorizontalTabViewRow {
                        TimerView()
                    } label: {
                        Label("Timer", systemImage: "timer")
                    },
                    
                    TabViewOrHorizontalTabViewRow {
                        SettingsView()
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                ])
            .accentColor(.primaryTheme)
            .onAppear {
                if #available(iOS 15.0, *) {
                    let appearance = UITabBarAppearance()
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
                
                store.dispatch(AppStateAction.loadSessions)
            }
            
            if state.isPresentingOverlay {
                OverlayAnimationView(text: state.overlayText) {
                    store.dispatch(MainViewStateAction.hideOverlay)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Store(initial: AppState(),
                                     reducer: AppState.reducer,
                                     middlewares: [Middlewares.overlayCheck, Middlewares.sessionsUpdate]))
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 13 mini")
    }
}
