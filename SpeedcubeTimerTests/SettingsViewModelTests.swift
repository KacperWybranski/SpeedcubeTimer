//
//  SettingsViewModelTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 01/04/2022.
//

import XCTest
@testable import SpeedcubeTimer

class SettingsViewModelTests: XCTestCase {

    private var viewModel: SettingsViewModel?
    private var appState: AppState = TestConfiguration.appState
    
    override func setUpWithError() throws {
        viewModel = .init(appState: appState)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testChangeCurrentSessionAfterSessionIndexChange() {
        let oldSession = appState.currentSession
        
        viewModel?.currentSessionIndex = TestConfiguration.newSessionIndex
        
        XCTAssertNotEqual(appState.currentSession, oldSession)
        XCTAssertEqual(appState.currentSession.index, TestConfiguration.newSessionIndex)
    }
    
    func testChangeCurrentSessionAfterCubeChange() {
        let oldSession = appState.currentSession
        
        viewModel?.currentCube = TestConfiguration.newCube
        
        XCTAssertNotEqual(appState.currentSession, oldSession)
        XCTAssertEqual(appState.currentSession.cube, TestConfiguration.newCube)
    }

}

private enum TestConfiguration {
    static let appState: AppState = .init(sessions: [session])
    
    static let session: CubingSession = .init(results: [Result(time: 5.0, scramble: "abc", date: .now)],
                                                   cube: .three,
                                                   index: 1)
    
    static let newSessionIndex = 2
    static let newCube = Cube.two
}
