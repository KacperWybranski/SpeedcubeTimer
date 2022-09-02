//
//  SettingsViewStateReducerTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 02/09/2022.
//

import XCTest

final class SettingsViewStateReducerTests: XCTestCase {
    
    func testNewAllSessionSet() {
        
        // Input
        
        let beforeSessions = Configuration.sampleSessions
        let afterSessions = Configuration.sampleSessions2
        let beforeState = SettingsViewState(allSessions: beforeSessions)
        let afterState = SettingsViewState(allSessions: afterSessions)
        
        // Reduce
        
        let reduced = SettingsViewState.reducer(beforeState, AppStateAction.newAllSessionsSet(Configuration.sampleSessions2))
        
        // Test
        
        XCTAssertEqual(afterState, reduced)
        
    }
}

private enum Configuration {
    static let sampleSessions: [CubingSession] = [
        .init(results: [], cube: .three, index: 1),
        .init(results: [], cube: .three, index: 5),
        .init(results: [], cube: .two, index: 2)
    ]
    static let sampleSessions2: [CubingSession] = [
        .init(results: [], cube: .four, index: 1),
        .init(results: [], cube: .four, index: 9)
    ]
}
