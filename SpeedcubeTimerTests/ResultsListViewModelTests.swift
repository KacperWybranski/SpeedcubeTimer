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
        appState = TestConfiguration.appState
        viewModel = .init(appState: appState)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testRemoveResultAt() {
        let result = Result(time: 8.33, scramble: "abcabc", date: .now)
        
        viewModel?.appState.addNewResult(result)
        
        XCTAssertEqual(viewModel?.appState.currentSession.results.first, result)
        
        viewModel?.removeResult(at: IndexSet(integer: 0))
        
        XCTAssertNotEqual(viewModel?.appState.currentSession.results.first, result)
    }
    
    func testAverageOfLastAndMeanOfLast() {
        viewModel?.appState.currentSession.results = TestConfiguration.resultsForAverage
        XCTAssertEqual(viewModel?.averageOfLast(5), TestConfiguration.expectedAverage)
        XCTAssertEqual(viewModel?.meanOfLast(5), TestConfiguration.expectedMean)
        
        XCTAssertEqual(viewModel?.averageOfLast(10), "-")
        XCTAssertEqual(viewModel!.meanOfLast(10), "-")
    }
}

private enum TestConfiguration {
    static let appState: AppState = .init(sessions: [session])
    static let session: CubingSession = .init(results: [],
                                                   cube: .three,
                                                   index: 1)
    
    static let resultsForAverage: [Result] = [.init(time: 0.10, scramble: "abc", date: .now),
                                              .init(time: 2.00, scramble: "abc", date: .now),
                                              .init(time: 2.50, scramble: "avc", date: .now),
                                              .init(time: 3.00, scramble: "abc", date: .now),
                                              .init(time: 89.00, scramble: "abc", date: .now)]
    static let expectedAverage: String = 2.50.asTextWithTwoDecimal
    static let expectedMean: String = 19.32.asTextWithTwoDecimal
}
