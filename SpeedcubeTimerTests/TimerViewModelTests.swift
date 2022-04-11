//
//  TimerViewModelTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 01/04/2022.
//

import SwiftUI
import XCTest
@testable import SpeedcubeTimer

class TimerViewModelTests: XCTestCase {
    
    private var appState: AppState?
    private var viewModel: TimerViewModel?

    override func setUpWithError() throws {
        let newAppState = TestConfiguration.appState
        appState = newAppState
        viewModel = TimerViewModel(appState: newAppState)
    }

    override func tearDownWithError() throws {
        appState = nil
        viewModel = nil
    }

    func testInitialState() {
        XCTAssertNotEqual(viewModel?.scramble, .empty)
        XCTAssertEqual(viewModel?.shouldScrambleBeHidden, TestConfiguration.initialStateShouldScrambleBeHidden)
        XCTAssertEqual(viewModel?.timerTextColor, TestConfiguration.initialStateTimerTextColor)
        XCTAssertEqual(viewModel?.time, TestConfiguration.initialStateTime)
    }
    
    func testReadyState() {
        viewModel?.touchBegan()
        XCTAssertEqual(viewModel?.shouldScrambleBeHidden, TestConfiguration.readyStateShouldScrambleBeHidden)
        XCTAssertEqual(viewModel?.timerTextColor, TestConfiguration.readyStateTimerTextColor)
        XCTAssertEqual(viewModel?.time, TestConfiguration.readyStateTime)
    }
    
    func testRunningState() {
        let expectation = XCTestExpectation(description: "after running for 3 seconds")
        
        viewModel?.touchBegan()
        viewModel?.touchEnded()
        
        XCTAssertEqual(viewModel?.shouldScrambleBeHidden, TestConfiguration.runningStateShouldScrambleBeHidden)
        XCTAssertEqual(viewModel?.timerTextColor, TestConfiguration.runningStateTimerTextColor)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotEqual(self.viewModel?.time, TestConfiguration.runningStateNotValidTime)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testEndedState() {
        let expectation = XCTestExpectation(description: "after running for 3 seconds")
        
        viewModel?.touchBegan()
        viewModel?.touchEnded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel?.touchBegan()
            
            XCTAssertEqual(self.viewModel?.shouldScrambleBeHidden, TestConfiguration.endedStateShouldScrambleBeHidden)
            XCTAssertEqual(self.viewModel?.timerTextColor, TestConfiguration.endedStateTimerTextColor)
            XCTAssertNotEqual(self.viewModel?.time, TestConfiguration.endedStateNotValidTime)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testNewInitialState() {
        let expectation = XCTestExpectation(description: "initial state set")
        let initialScramble = viewModel?.scramble
        
        viewModel?.touchBegan()
        viewModel?.touchEnded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.viewModel?.touchBegan()
            self.viewModel?.touchEnded()
            
            XCTAssertEqual(self.viewModel?.shouldScrambleBeHidden, TestConfiguration.idleStateShouldScrambleBeHidden)
            XCTAssertEqual(self.viewModel?.timerTextColor, TestConfiguration.idleStateTimerTextColor)
            XCTAssertNotEqual(self.viewModel?.time, TestConfiguration.idleStateNotValidTime)
            XCTAssertNotEqual(self.viewModel?.scramble, initialScramble)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testResetAfterSessionChange() {
        let expectation = XCTestExpectation(description: "on end solve")
        let previousScramble = viewModel?.scramble
        
        viewModel?.touchBegan()
        viewModel?.touchEnded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel?.touchBegan()
            self.viewModel?.touchEnded()
            
            XCTAssertNotEqual(self.viewModel?.time, TestConfiguration.endedStateNotValidTime)
            
            self.appState?.changeSessionTo(cube: .three, index: 2)
            
            XCTAssertEqual(self.viewModel?.shouldScrambleBeHidden, TestConfiguration.initialStateShouldScrambleBeHidden)
            XCTAssertEqual(self.viewModel?.timerTextColor, TestConfiguration.initialStateTimerTextColor)
            XCTAssertEqual(self.viewModel?.time, TestConfiguration.initialStateTime)
            XCTAssertNotEqual(self.viewModel?.scramble, previousScramble)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSaveNewResult() {
        let expectation = XCTestExpectation(description: "on save new result")
        let scramble = viewModel?.scramble
        let results = appState!.currentSession.results
        
        viewModel?.touchBegan()
        viewModel?.touchEnded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewModel?.touchBegan()
            
            XCTAssertEqual(self.appState?.currentSession.results.count, results.count + 1)
            XCTAssertEqual(self.appState?.currentSession.results.first?.scramble, scramble)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFormattedTime() {
        appState?.isPreinspectionOn.toggle()

        viewModel?.touchBegan()
        viewModel?.touchEnded()

        XCTAssertEqual(viewModel?.formattedTime, viewModel?.time.asTextOnlyFractionalPart)

        viewModel?.touchBegan()
        viewModel?.touchEnded()

        XCTAssertEqual(viewModel?.formattedTime, viewModel?.time.asTextWithTwoDecimal)
        
        appState?.isPreinspectionOn.toggle()
    }
}

private enum TestConfiguration {
    // initial state
    static let initialStateTime: TimeInterval = 0.0
    static let initialStateShouldScrambleBeHidden: Bool = false
    static let initialStateTimerTextColor: Color = .white
    
    // ready state
    static let readyStateTime: TimeInterval = 0.0
    static let readyStateShouldScrambleBeHidden: Bool = false
    static let readyStateTimerTextColor: Color = .yellow
    
    // running state
    static let runningStateNotValidTime: TimeInterval = 0.0
    static let runningStateShouldScrambleBeHidden: Bool = true
    static let runningStateTimerTextColor: Color = .green
    
    //ended state
    static let endedStateNotValidTime: TimeInterval = 0.0
    static let endedStateShouldScrambleBeHidden: Bool = true
    static let endedStateTimerTextColor: Color = .red
    
    //idle state after ended
    static let idleStateNotValidTime: TimeInterval = 0.0
    static let idleStateShouldScrambleBeHidden: Bool = false
    static let idleStateTimerTextColor: Color = .white
    
    //reset after session change
    static let appState: AppState = .init(sessions: [session])
    
    static let session: CubingSession = .init(results: [Result(time: 5.0, scramble: "abc", date: .now)],
                                                   cube: .three,
                                                   session: 1)
}
