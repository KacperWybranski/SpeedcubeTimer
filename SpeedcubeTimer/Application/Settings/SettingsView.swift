//
//  SettingsView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 26/03/2022.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section("Current session") {
                    Picker("Cube", selection: $viewModel.currentCube) {
                        ForEach(viewModel.allCubeOptions, id: \.self) { option in
                            Text(option.name)
                        }
                    }
                    Picker("Session", selection: $viewModel.currentSessionIndex) {
                        ForEach(viewModel.allSessionOptions, id: \.self) { option in
                            Text(option.name)
                        }
                    }
                }
                
                Section("General") {
                    Toggle("Preinspection", isOn: $viewModel.appSettings.isPreinspectionOn)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
