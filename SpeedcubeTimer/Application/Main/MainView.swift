//
//  MainView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 24/03/2022.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    @State private var selection: Int = 1
    
    var body: some View { 
        TabView(selection: $selection) {
            ResultsListView(viewModel: viewModel.resultsListViewModel)
                .tabItem {
                    Label("Results", systemImage: "list.number")
                }
                .tag(0)
            TimerView(viewModel: viewModel.timerViewModel)
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
                .tag(1)
            SettingsView(viewModel: viewModel.settingsViewModel)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(2)
        }
        .accentColor(.green)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
            .preferredColorScheme(.dark)
    }
}
