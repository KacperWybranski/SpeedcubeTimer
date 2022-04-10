//
//  ResultsListViewModel.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 29/03/2022.
//

import Foundation
import SwiftUI

class ResultsListViewModel: ObservableObject {
    var settings: AppSettings
    
    init(settings: AppSettings) {
        self.settings = settings
    }
    
    func removeResult(at offsets: IndexSet) {
        settings.remove(at: offsets)
    }
}
