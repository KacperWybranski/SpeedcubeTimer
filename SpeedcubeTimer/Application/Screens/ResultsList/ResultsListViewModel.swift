//
//  ResultsListViewModel.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 29/03/2022.
//

import Foundation
import SwiftUI

class ResultsListViewModel: ObservableObject {
    @ObservedObject var appState: AppState
    
    private var averageNotSetPlaceholder = "-"
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    func removeResult(at offsets: IndexSet) {
        appState.remove(at: offsets)
    }
    
    func averageOfLast(_ count: Int) -> String {
        appState.averageOfLast(count)?.asTextWithTwoDecimal ?? averageNotSetPlaceholder
    }
    
    func meanOfLast(_ count: Int) -> String {
        appState.meanOfLast(count)?.asTextWithTwoDecimal ?? averageNotSetPlaceholder
    }
    
    func averageName(_ averageOf: AverageOrMeanOf) -> String {
        switch averageOf {
        case .five:
            return "average of 5"
        case .twelve:
            return "average of 12"
        case .hundred:
            return "mean of 100"
        }
    }
    
    enum AverageOrMeanOf {
        case five
        case twelve
        case hundred
    }
}
