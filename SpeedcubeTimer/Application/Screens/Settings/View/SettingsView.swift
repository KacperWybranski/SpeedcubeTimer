//
//  SettingsView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 26/03/2022.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    let store: Store<SettingsFeature.State, SettingsFeature.Action>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                Form {
                    Section(header: Text("Current session")) {
                        Picker("Cube",
                               selection: viewStore
                                                .binding(
                                                    get: { $0.currentSession.cube },
                                                    send: { .cubeChanged($0) }
                                                )
                        ) {
                            ForEach(
                                SettingsFeature
                                    .State
                                    .availableCubes,
                                id: \.self
                            ) { option in
                                Text(option.name)
                            }
                        }
                        
                        Picker("Session",
                               selection: viewStore
                                                .binding(
                                                    get: { $0.currentSession.index },
                                                    send: { .sessionIndexChanged($0) }
                                                )
                        ) {
                            ForEach(
                                SettingsFeature
                                    .State
                                    .availableSessionNums,
                                id: \.self
                            ) { option in
                                Text("\(option) \(viewStore.state.identifierForSession(with: option)?.wrappedInParentheses(true) ?? .empty)")
                            }
                        }
                        
                        TextField("Session identifier",
                                  text: viewStore
                                                .binding(
                                                    get: { $0.currentSession.name ?? .empty },
                                                    send: { .currentSessionNameChanged($0) }
                                                )
                        )
                        
                        Button {
                            viewStore
                                .send(
                                    .showEraseSessionPopup(true)
                                )
                        } label: {
                            Text("Erase")
                                .foregroundColor(.red)
                        }
//                        .alert(
//                            isPresented: viewStore
//                                            .binding(
//                                                get: { $0.isPresentingEraseSessionPopup },
//                                                send: { !$0 ? .showEraseSessionPopup($0) :  }
//                                            )
//                        ) {
//                            Alert(title: Text("Erase current session?"),
//                                  message: Text("Current session name and all results from this session will be removed."),
//                                  primaryButton: .destructive(
//                                                        Text("Yes"),
//                                                        action: {
//                                                            viewStore
//                                                                .send(
//                                                                    .eraseSession(viewStore.currentSession)
//                                                                )
//                                                        }
//                                  ),
//                                  secondaryButton: .default(
//                                                        Text("No")
//                                  )
//                            )
//                        }
                    }
                    
                    Section(header: Text("General")) {
                        Toggle("Preinspection",
                               isOn: viewStore
                                            .binding(
                                                get: { $0.isPreinspectionOn },
                                                send: { .isPreinspectionOnChanged($0) }
                                            )
                        )

                        Button {
                            viewStore
                                .send(
                                    .showResetActionSheet(true)
                                )
                        } label: {
                            Text("Reset")
                                .foregroundColor(.red)
                        }
//                        .actionSheet(
//                            isPresented: viewStore
//                                .binding(
//                                    get: { $0.isPresentingResetActionSheet },
//                                    send: { !$0 ? .showResetActionSheet($0) : .none }
//                                )
//                        ) {
//                            ActionSheet(title: Text("Reset app data?"),
//                                        message: Text("All data including results in every session will be removed. This action cannot be undone."),
//                                        buttons: [
//                                            .destructive(
//                                                Text("Reset app data"),
//                                                action: {
//                                                    viewStore
//                                                        .send(
//                                                            .showResetAppPopup(true)
//                                                        )
//                                                }
//                                            ),
//                                            .default(
//                                                Text("Reset only current session"),
//                                                action: {
//                                                    viewStore
//                                                        .send(
//                                                            .showEraseSessionPopup(true)
//                                                        )
//                                                }
//                                            ),
//                                            .default(
//                                                Text("Cancel")
//                                            )
//                                        ])
//                        }
//                        .alert(
//                            isPresented: viewStore
//                                                .binding(
//                                                    get: { $0.isPresentingResetAppPopup },
//                                                    send: { !$0 ? .showEraseSessionPopup($0) : .none }
//                                                )
//                        ) {
//                            Alert(title: Text("Reset app data?"),
//                                  message: Text("You will lose all your results and settings. This action cannot be undone."),
//                                  primaryButton: .destructive(
//                                                        Text("Yes"),
//                                                        action: {
//                                                            viewStore
//                                                                .send(
//                                                                    .resetApp
//                                                                )
//                                                        }
//                                  ),
//                                  secondaryButton: .default(
//                                                        Text("No")
//                                  )
//                            )
//                        }
                    }
                }
                .navigationTitle("Settings")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            store: Store(
                initialState: SettingsFeature.State(),
                reducer: SettingsFeature.reducer,
                environment: . init(
                    sessionsManager: SessionsManager()
                )
            )
        )
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
