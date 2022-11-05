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
                                    .showEraseSessionPopup
                                )
                        } label: {
                            Text("Erase")
                                .foregroundColor(.red)
                        }
                        .alert(
                            self.store.scope(state: \.alert),
                            dismiss: .dismissPopup
                        )
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
                                    .showResetPopup
                                )
                        } label: {
                            Text("Reset")
                                .foregroundColor(.red)
                        }
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
