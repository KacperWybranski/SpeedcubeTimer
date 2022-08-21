//
//  ResultsViewStateReducerTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 21/08/2022.
//

import Foundation
import XCTest

class ResultsViewStateReducerTests: XCTestCase {
    
    override func setUpWithError() throws { }
    
    override func tearDownWithError() throws { }
    
    func testNewSessionSet() {
        
        // Input
        
        let session1 = Configuration.sessionCubeThreeIndexOne
        let session2 = Configuration.sessionCubeThreeIndexTwo
        
        let resultsViewStateBefore = ResultsViewState(currentSession: session1)
        let resultsViewStateAfter = ResultsViewState(currentSession: session2)
        
        // Reduce
        
        let reduced = ResultsViewState.reducer(resultsViewStateBefore, AppStateAction.newSessionSet(session2))
        
        // Test
        
        XCTAssertEqual(reduced, resultsViewStateAfter)
    }
    
}

private enum Configuration {
    static let sessionCubeThreeIndexOne = CubingSession(results: [], cube: .three, index: 1)
    static let sessionCubeThreeIndexTwo = CubingSession(results: [], cube: .three, index: 2)
}
