//
//  AppStateTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 11/04/2022.
//

import XCTest
@testable import SpeedcubeTimer

class AppStateTests: XCTestCase {

    private var appState: AppState?
    
    override func setUpWithError() throws {
        appState = .init(sessions: [TestConfiguration.firstSession, TestConfiguration.secondSession])
    }

    override func tearDownWithError() throws {
        appState = nil
    }

    func testCurrentSessionIsFirstSessionFromInitial() {
        XCTAssertEqual(appState?.currentSession, TestConfiguration.firstSession)
    }
    
    func testChangeSessionToExistingOne() {
        appState?.changeSessionTo(cube: TestConfiguration.secondSessionCube, index: TestConfiguration.secondSessionIndex)
        
        XCTAssertEqual(appState?.currentSession, TestConfiguration.secondSession)
    }
    
    func testChangeSessionToNewOne() {
        appState?.changeSessionTo(cube: TestConfiguration.thirdSessionCube, index: TestConfiguration.thirdSessionIndex)
        
        XCTAssertNotEqual(appState?.currentSession, TestConfiguration.firstSession)
        XCTAssertNotEqual(appState?.currentSession, TestConfiguration.secondSession)
        XCTAssertEqual(appState?.currentSession.cube, TestConfiguration.thirdSessionCube)
        XCTAssertEqual(appState?.currentSession.index, TestConfiguration.thirdSessionIndex)
    }
    
    func testAddNewResult() {
        let resultsCount = appState?.currentSession.results.count
        appState?.addNewResult(TestConfiguration.resultToAdd)
        
        XCTAssertEqual(appState?.currentSession.results.first, TestConfiguration.resultToAdd)
        XCTAssertEqual((resultsCount ?? 0) + 1, appState?.currentSession.results.count)
    }
    
    func testAddFirstResultBest() {
        let resultToAdd = TestConfiguration.resultToAdd
        appState?.currentSession = TestConfiguration.emptySession
        appState?.addNewResult(resultToAdd)
        
        XCTAssertEqual(appState?.currentSession.bestResult, resultToAdd)
    }
    
    func testAddNewBestResult() {
        let newBestResult = TestConfiguration.resultToAdd
        appState?.addNewResult(newBestResult)
        
        XCTAssertEqual(appState?.currentSession.bestResult, newBestResult)
    }
    
    func testAverageOfLastAndMeanOfLast() {
        appState?.currentSession.results = TestConfiguration.resultsForAverage
        XCTAssertEqual(appState?.averageOfLast(5), TestConfiguration.expectedAverage)
        XCTAssertEqual(appState?.meanOfLast(5), TestConfiguration.expectedMean)
        
        XCTAssertEqual(appState?.averageOfLast(10), nil)
        XCTAssertEqual(appState?.meanOfLast(10), nil)
    }
}

private enum TestConfiguration {
    static let firstSession: CubingSession = .init(results: [Result(time: 5.0, scramble: "abc", date: .now)],
                                                   cube: .three,
                                                   index: 1)
    static let secondSession: CubingSession = .init(results: [Result(time: 9.0, scramble: "dce", date: .now)],
                                                    cube: secondSessionCube,
                                                    index: secondSessionIndex)
    
    static let emptySession: CubingSession = .init(results: [], cube: .three, index: 1)
    
    static let secondSessionCube: Cube = .three
    static let secondSessionIndex = 2
    
    static let thirdSessionCube: Cube = .two
    static let thirdSessionIndex = 5
    
    static let defaultInitialSession: CubingSession = .init(results: [], cube: .three, index: 1)
    
    static let resultToAdd: Result = .init(time: 2.23, scramble: "scramble", date: .now)
    
    static let resultsForAverage: [Result] = [.init(time: 0.10, scramble: "abc", date: .now),
                                              .init(time: 2.00, scramble: "abc", date: .now),
                                              .init(time: 2.50, scramble: "avc", date: .now),
                                              .init(time: 3.00, scramble: "abc", date: .now),
                                              .init(time: 89.00, scramble: "abc", date: .now)]
    static let expectedAverage: TimeInterval = 2.50
    static let expectedMean: TimeInterval = 19.32
}

