//
//  AppSetingsTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 01/04/2022.
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
    
    func testCurrentSessionWhenInitWithEmptySessions() {
        appState = .init(sessions: [])
        
        XCTAssertEqual(appState?.currentSession, TestConfiguration.defaultInitialSession)
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
        XCTAssertEqual(appState?.currentSession.sessionindex, TestConfiguration.thirdSessionIndex)
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
}

private enum TestConfiguration {
    static let firstSession: CubingSession = .init(results: [Result(time: 5.0, scramble: "abc", date: .now)],
                                                   cube: .three,
                                                   session: 1)
    static let secondSession: CubingSession = .init(results: [Result(time: 9.0, scramble: "dce", date: .now)],
                                                    cube: secondSessionCube,
                                                    session: secondSessionIndex)
    
    static let emptySession: CubingSession = .init(results: [], cube: .three, session: 1)
    
    static let secondSessionCube: Cube = .three
    static let secondSessionIndex = 2
    
    static let thirdSessionCube: Cube = .two
    static let thirdSessionIndex = 5
    
    static let defaultInitialSession: CubingSession = .init(results: [], cube: .three, session: 1)
    
    static let resultToAdd: Result = .init(time: 2.23, scramble: "scramble", date: .now)
}
