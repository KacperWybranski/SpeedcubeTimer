//
//  ResultsListViewModelTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 03/04/2022.
//

import XCTest
@testable import SpeedcubeTimer

class ResultsListViewModelTests: XCTestCase {
    
    private var appState: AppState = TestConfiguration.appState
    private var viewModel: ResultsListViewModel?

    override func setUpWithError() throws {
        viewModel = .init(appState: appState)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testRemoveResultAt() {
        let result = Result(time: 8.33, scramble: "abcabc", date: .now)
        
        appState.currentSession.results.append(result)
        
        XCTAssertEqual(appState.currentSession.results.first, result)
        
        viewModel?.removeResult(at: IndexSet(integer: 0))
        
        XCTAssertEqual(viewModel?.appState.currentSession.results.isEmpty, true)
    }
}

private enum TestConfiguration {
    static let appState: AppState = .init(sessions: [session])
    static let session: CubingSession = .init(results: [],
                                                   cube: .three,
                                                   session: 1)
}
