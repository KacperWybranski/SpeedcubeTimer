//
//  SettingsView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 26/03/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store<AppState>
    
    private var state: SettingsViewState { store.state.screenState(for: .settings) ?? .init() }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Current session")) {
                    Picker("Cube", selection: Binding(get: { state.currentSession.cube },
                                                      set: { store.dispatch(SettingsViewStateAction.cubeChanged($0)) })) {
                        ForEach(SettingsViewState.availableCubes, id: \.self) { option in
                            Text(option.name)
                        }
                    }
                    
                    Picker("Session", selection: Binding(get: { state.currentSession.index },
                                                         set: { store.dispatch(SettingsViewStateAction.sessionIndexChanged($0)) })) {
                        ForEach(SettingsViewState.availableSessionNums, id: \.self) { option in
                            Text("\(option) \(state.identifierForSession(with: state.currentSession.cube, and: option)?.wrappedInParentheses(true) ?? .empty)")
                        }
                    }
                    
                    TextField("Session identifier", text: Binding(get: { state.currentSession.name ?? .empty },
                                                                  set: { store.dispatch(SettingsViewStateAction.currentSessionNameChanged($0)) }))
                }
                
                Section(header: Text("General")) {
                    Toggle("Preinspection", isOn: Binding(get: { state.isPreinspectionOn },
                                                          set: { store.dispatch(SettingsViewStateAction.isPreinspectionOnChanged($0)) }))
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(
                Store(initial:
                        AppState(allSessions: CubingSession.previewSessions,
                                 currentSession: CubingSession.previewSessions.first ?? .init(),
                                 screens: [.settingsScreen(SettingsViewState(allSessions: CubingSession.previewSessions))]),
                      reducer: AppState.reducer))
            .preferredColorScheme(.dark)
    }
}

private extension CubingSession {
    static var previewSessions: [CubingSession] {
        [
            .init(results: [], cube: .three, index: 1, name: "one hand"),
            .init(results: [], cube: .three, index: 5, name: "test"),
            .init(results: [], cube: .three, index: 8, name: "feet")
        ]
    }
}
