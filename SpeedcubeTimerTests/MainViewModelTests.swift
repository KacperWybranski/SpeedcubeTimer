//
//  MainViewModelTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 01/04/2022.
//

import XCTest
@testable import SpeedcubeTimer

class MainViewModelTests: XCTestCase {

    private var viewModel: MainViewModel?
    
    override func setUpWithError() throws {
        viewModel = .init()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testChangeCurrentSession() {
        let oldSession = viewModel?.appState.currentSession
        
        viewModel?.setSessionTo(cube: TestConfiguration.newCube, index: TestConfiguration.newSessionIndex)
        
        XCTAssertNotEqual(viewModel?.appState.currentSession, oldSession)
        XCTAssertEqual(viewModel?.appState.currentSession.cube, TestConfiguration.newCube)
        XCTAssertEqual(viewModel?.appState.currentSession.index, TestConfiguration.newSessionIndex)
    }

}

private enum TestConfiguration {
    static let newSessionIndex = 2
    static let newCube = Cube.two
}
