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
    
    @State private var currentCube: Cube = .three
    @State private var currentSession: Int = 1
    @State private var sessionName: String = .empty
    @State private var isPreinspectionOn: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Current session")) {
                    Picker("Cube", selection: $currentCube) {
                        ForEach(SettingsViewState.availableCubes, id: \.self) { option in
                            Text(option.name)
                        }
                    }
                    
                    Picker("Session", selection: $currentSession) {
                        ForEach(SettingsViewState.availableSessionNums, id: \.self) { option in
                            Text("\(option) \(state.identifierForSession(with: currentCube, and: option)?.wrappedInParentheses(true) ?? .empty)")
                        }
                    }
                    
                    TextField("Session identifier", text: $sessionName, onCommit: {
                        store.dispatch(SettingsViewStateAction.currentSessionNameChanged(sessionName))
                    })
                }
                
                Section(header: Text("General")) {
                    Toggle("Preinspection", isOn: $isPreinspectionOn)
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                sessionName = state.identifierForSession(with: currentCube, and: currentSession) ?? .empty
            }
            .onChange(of: currentCube) {
                store.dispatch(SettingsViewStateAction.cubeChanged($0))
            }
            .onChange(of: currentSession) {
                store.dispatch(SettingsViewStateAction.sessionIndexChanged($0))
            }
            .onChange(of: isPreinspectionOn) {
                store.dispatch(SettingsViewStateAction.isPreinspectionOnChanged($0))
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Store(initial: AppState(), reducer: AppState.reducer))
            .preferredColorScheme(.dark)
        
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
