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
    private var settings: AppSettings = TestConfiguration.settings
    
    override func setUpWithError() throws {
        viewModel = .init(settings: settings)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testChangeCurrentSessionAfterSessionIndexChange() {
        let oldSession = settings.currentSession
        
        viewModel?.currentSessionIndex = TestConfiguration.newSessionIndex
        
        XCTAssertNotEqual(settings.currentSession, oldSession)
        XCTAssertEqual(settings.currentSession.sessionindex, TestConfiguration.newSessionIndex)
    }
    
    func testChangeCurrentSessionAfterCubeChange() {
        let oldSession = settings.currentSession
        
        viewModel?.currentCube = TestConfiguration.newCube
        
        XCTAssertNotEqual(settings.currentSession, oldSession)
        XCTAssertEqual(settings.currentSession.cube, TestConfiguration.newCube)
    }

}

private enum TestConfiguration {
    static let settings: AppSettings = .init(sessions: [session])
    
    static let session: CubingSession = .init(results: [Result(time: 5.0, scramble: "abc", date: .now)],
                                                   cube: .three,
                                                   session: 1)
    
    static let newSessionIndex = 2
    static let newCube = Cube.two
}
