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
                            Text("\(option) \(state.identifierForSession(with: option)?.wrappedInParentheses(true) ?? .empty)")
                        }
                    }
                    
                    TextField("Session identifier", text: Binding(get: { state.currentSession.name ?? .empty },
                                                                  set: { store.dispatch(SettingsViewStateAction.currentSessionNameChanged($0)) }))
                    
                    Button {
                        store.dispatch(SettingsViewStateAction.showEraseSessionPopup(true))
                    } label: {
                        Text("Erase")
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: Binding(get: { state.isPresentingEraseSessionPopup },
                                                set: { if !$0 { store.dispatch(SettingsViewStateAction.showEraseSessionPopup($0)) } })) {
                        Alert(title: Text("Erase current session?"),
                              message: Text("Current session name and all results from this session will be removed."),
                              primaryButton: .destructive(Text("Yes"), action: { store.dispatch(SettingsViewStateAction.eraseSession) }),
                              secondaryButton: .default(Text("No")))
                    }
                }
                
                Section(header: Text("General")) {
                    Toggle("Preinspection", isOn: Binding(get: { state.isPreinspectionOn },
                                                          set: { store.dispatch(SettingsViewStateAction.isPreinspectionOnChanged($0)) }))
                    
                    Button {
                        store.dispatch(SettingsViewStateAction.showResetActionSheet(true))
                    } label: {
                        Text("Reset")
                            .foregroundColor(.red)
                    }
                    .actionSheet(isPresented: Binding(get: { state.isPresentingResetActionSheet },
                                                      set: { if !$0 { store.dispatch(SettingsViewStateAction.showResetActionSheet($0)) } }),
                                 content: {
                        ActionSheet(title: Text("Reset app data?"),
                                    message: Text("All data including results in every session will be removed. This action cannot be undone."),
                                    buttons: [
                                        .destructive(Text("Reset app data"), action: { store.dispatch(SettingsViewStateAction.showResetAppPopup(true)) }),
                                        .default(Text("Reset only current session"), action: { store.dispatch(SettingsViewStateAction.showEraseSessionPopup(true)) }),
                                        .default(Text("Cancel"))
                                    ])
                    })
                    .alert(isPresented: Binding(get: { state.isPresentingResetAppPopup },
                                                set: { if !$0 { store.dispatch(SettingsViewStateAction.showResetAppPopup($0)) } })) {
                        Alert(title: Text("Reset app data?"),
                              message: Text("You will lose all your results and settings. This action cannot be undone."),
                              primaryButton: .destructive(Text("Yes"), action: { store.dispatch(SettingsViewStateAction.resetApp) }),
                              secondaryButton: .default(Text("No")))
                    }
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
