//
//  AppSetingsTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 01/04/2022.
//

import XCTest
@testable import SpeedcubeTimer

class AppSettingsTests: XCTestCase {

    private var settings: AppSettings?
    
    override func setUpWithError() throws {
        settings = .init(sessions: [TestConfiguration.firstSession, TestConfiguration.secondSession])
    }

    override func tearDownWithError() throws {
        settings = nil
    }

    func testCurrentSessionIsFirstSessionFromInitial() {
        XCTAssertEqual(settings?.currentSession, TestConfiguration.firstSession)
    }
    
    func testCurrentSessionWhenInitWithEmptySessions() {
        settings = .init(sessions: [])
        
        XCTAssertEqual(settings?.currentSession, TestConfiguration.defaultInitialSession)
    }
    
    func testChangeSessionToExistingOne() {
        settings?.changeSessionTo(cube: TestConfiguration.secondSessionCube, index: TestConfiguration.secondSessionIndex)
        
        XCTAssertEqual(settings?.currentSession, TestConfiguration.secondSession)
    }
    
    func testChangeSessionToNewOne() {
        settings?.changeSessionTo(cube: TestConfiguration.thirdSessionCube, index: TestConfiguration.thirdSessionIndex)
        
        XCTAssertNotEqual(settings?.currentSession, TestConfiguration.firstSession)
        XCTAssertNotEqual(settings?.currentSession, TestConfiguration.secondSession)
        XCTAssertEqual(settings?.currentSession.cube, TestConfiguration.thirdSessionCube)
        XCTAssertEqual(settings?.currentSession.sessionindex, TestConfiguration.thirdSessionIndex)
    }
}

private enum TestConfiguration {
    static let firstSession: CubingSession = .init(results: [Result(time: 5.0, scramble: "abc", date: .now)],
                                                   cube: .three,
                                                   session: 1)
    static let secondSession: CubingSession = .init(results: [Result(time: 9.0, scramble: "dce", date: .now)],
                                                    cube: secondSessionCube,
                                                    session: secondSessionIndex)
    
    static let secondSessionCube: Cube = .three
    static let secondSessionIndex = 2
    
    static let thirdSessionCube: Cube = .two
    static let thirdSessionIndex = 5
    
    static let defaultInitialSession: CubingSession = .init(results: [], cube: .three, session: 1)
}
