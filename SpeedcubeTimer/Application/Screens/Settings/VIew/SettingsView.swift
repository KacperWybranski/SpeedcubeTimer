//
//  SettingsView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 26/03/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store<AppState>
    
    @State private var currentCube: Cube = .three
    @State private var currentSession: Int = 1
    @State private var isPreinspectionOn: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Current session") {
                    Picker("Cube", selection: $currentCube) {
                        ForEach(Cube.allCases, id: \.self) { option in
                            Text(option.name)
                        }
                    }
                    
                    Picker("Session", selection: $currentSession) {
                        ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], id: \.self) { option in
                            Text("\(option)")
                        }
                    }
                }
                
                Section("General") {
                    Toggle("Preinspection", isOn: $isPreinspectionOn)
                }
            }
            .navigationTitle("Settings")
            .onChange(of: currentCube) {
                store.dispatch(SettingsViewStateAction.cubeChanged($0))
            }
            .onChange(of: currentSession) {
                store.dispatch(SettingsViewStateAction.sessionChanged($0))
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
    }
}
