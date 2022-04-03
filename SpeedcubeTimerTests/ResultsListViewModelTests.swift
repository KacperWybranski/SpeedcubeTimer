//
//  ResultsListViewModelTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 03/04/2022.
//

import XCTest
@testable import SpeedcubeTimer

class ResultsListViewModelTests: XCTestCase {
    
    private var settings: AppSettings = TestConfiguration.settings
    private var viewModel: ResultsListViewModel?

    override func setUpWithError() throws {
        viewModel = .init(settings: settings)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testRemoveResultAt() {
        let result = Result(time: 8.33, scramble: "abcabc", date: .now)
        
        settings.currentSession.results.append(result)
        
        XCTAssertEqual(settings.currentSession.results.first, result)
        
        viewModel?.removeResult(at: IndexSet(integer: 0))
        
        XCTAssertEqual(viewModel?.settings.currentSession.results.isEmpty, true)
    }
}

private enum TestConfiguration {
    static let settings: AppSettings = .init(sessions: [session])
    static let session: CubingSession = .init(results: [],
                                                   cube: .three,
                                                   session: 1)
}
