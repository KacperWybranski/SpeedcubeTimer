//
//  ResultsListViewModel.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 29/03/2022.
//

import Foundation
import SwiftUI

class ResultsListViewModel: ObservableObject {
    var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    func removeResult(at offsets: IndexSet) {
        appState.remove(at: offsets)
    }
}
