//
//  TimerViewStateReducerTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 21/08/2022.
//

import Foundation
import XCTest

class TimerViewStateReducerTests: XCTestCase {
    
    override func setUpWithError() throws { }
    
    override func tearDownWithError() throws { }
    
    func testNewSessionSet() {
        
        // Input
        
        let session1 = Configuration.sessionCubeThreeIndexOne
        let session2 = Configuration.sessionCubeThreeIndexTwo
        
        let timerViewStateBefore = TimerViewState(session: session1)
        let timerViewStateAfter = TimerViewState(session: session2)
        
        // Reduce
        
        let reduced = TimerViewState.reducer(timerViewStateBefore, AppStateAction.newSessionSet(session2))
        
        // Test
        
        XCTAssertEqual(reduced.cube, timerViewStateAfter.cube)
        XCTAssertEqual(reduced.cubingState, timerViewStateAfter.cubingState)
        XCTAssertEqual(reduced.time, timerViewStateAfter.time)
        XCTAssertEqual(reduced.isPreinspectionOn, timerViewStateAfter.isPreinspectionOn)
    }
    
    func testIsPreinspectionOnSwitched() {
        
        // Input
        
        let timerViewStateBefore = Configuration.timerStateDefault
        let timerViewStateAfter = Configuration.timerStatePreinspectionOn
        
        // Reduce
        
        let reduced = TimerViewState.reducer(timerViewStateBefore, SettingsViewStateAction.isPreinspectionOnChanged(true))
        
        // Test
        
        XCTAssertEqual(reduced.cube, timerViewStateAfter.cube)
        XCTAssertEqual(reduced.cubingState, timerViewStateAfter.cubingState)
        XCTAssertEqual(reduced.time, timerViewStateAfter.time)
        XCTAssertEqual(reduced.scramble, timerViewStateAfter.scramble)
        XCTAssertEqual(reduced.isPreinspectionOn, timerViewStateAfter.isPreinspectionOn)
    }
    
    func testTouchBeganOnIdleState() {
        
        // Input
        
        let timerViewStateBefore = Configuration.timerStateDefault
        
        // Reduce
        
        let reduced = TimerViewState.reducer(timerViewStateBefore, TimerViewStateAction.touchBegan)
        
        // Test
        
        XCTAssertEqual(reduced.cubingState, .ready)
    }
    
    func testTouchEndedOnReadyState() {
        
        // Input
        
        let timerViewStateBefore = Configuration.timerStateReady
        
        // Reduce
        
        let reduced = TimerViewState.reducer(timerViewStateBefore, TimerViewStateAction.touchEnded)
        
        // Test
        
        XCTAssertEqual(reduced.cubingState, .ongoing)
    }
    
    func testTouchEndedOnReadyStateWithPreinspection() {
        
        // Input
        
        let timerViewStateBefore = Configuration.timerStateReadyPreinspectionOn
        
        // Reduce
        
        let reduced = TimerViewState.reducer(timerViewStateBefore, TimerViewStateAction.touchEnded)
        
        // Test
        
        XCTAssertEqual(reduced.cubingState, .preinspectionOngoing)
    }
    
    func testTouchBeganOnPreinspectionOngoingState() {
        
        // Input
        
        let timerViewStateBefore = Configuration.timerStatePreinspectionOngoing
        
        // Reduce
        
        let reduced = TimerViewState.reducer(timerViewStateBefore, TimerViewStateAction.touchBegan)
        
        // Test
        
        XCTAssertEqual(reduced.cubingState, .preinspectionReady)
    }
    
    func testTouchEndedOnPreinspectionReadyState() {
        
        // Input
        
        let timerViewStateBefore = Configuration.timerStatePreinspectionReady
        
        // Reduce
        
        let reduced = TimerViewState.reducer(timerViewStateBefore, TimerViewStateAction.touchEnded)
        
        // Test
        
        XCTAssertEqual(reduced.cubingState, .ongoing)
    }
    
    func testTouchBeganOnOngoingState() {
        
        // Input
        
        let timerViewStateBefore = Configuration.timerStateOngoing
        
        // Reduce
        
        let reduced = TimerViewState.reducer(timerViewStateBefore, TimerViewStateAction.touchBegan)
        
        // Test
        
        XCTAssertEqual(reduced.cubingState, .ended)
    }
    
    func testTouchEndedOnEndedState() {
        
        // Input
        
        let timerViewStateBefore = Configuration.timerStateEnded
        
        // Reduce
        
        let reduced = TimerViewState.reducer(timerViewStateBefore, TimerViewStateAction.touchEnded)
        
        // Test
        
        XCTAssertEqual(reduced.cubingState, .idle)
        XCTAssertNotEqual(reduced.scramble, timerViewStateBefore.scramble)
    }
    
    func testUpdateTimeOnTimerState() {
        
        // Input
        
        let timerViewStateBefore = Configuration.timerStateOngoing
        let newTime = 6.0
        
        // Reduce
        
        let reduced = TimerViewState.reducer(timerViewStateBefore, TimerViewStateAction.updateTime(newTime))
        
        // Test
        
        XCTAssertEqual(reduced.time, newTime)
    }
}

private enum Configuration {
    static let sessionCubeThreeIndexOne = CubingSession(results: [], cube: .three, index: 1)
    static let sessionCubeThreeIndexTwo = CubingSession(results: [], cube: .three, index: 2)
    
    static let timerStateDefault = TimerViewState(cubingState: .idle,
                                                  time: 0.0,
                                                  cube: .three,
                                                  scramble: "scramble",
                                                  isPreinspectionOn: false)
    static let timerStatePreinspectionOn = TimerViewState(cubingState: .idle,
                                                          time: 0.0,
                                                          cube: .three,
                                                          scramble: "scramble",
                                                          isPreinspectionOn: true)
    static let timerStateReady = TimerViewState(cubingState: .ready,
                                                time: 0.0,
                                                cube: .three,
                                                scramble: "scramble",
                                                isPreinspectionOn: false)
    static let timerStateReadyPreinspectionOn = TimerViewState(cubingState: .ready,
                                                time: 0.0,
                                                cube: .three,
                                                scramble: "scramble",
                                                isPreinspectionOn: true)
    static let timerStatePreinspectionOngoing = TimerViewState(cubingState: .preinspectionOngoing,
                                                               time: 13.0,
                                                               cube: .three,
                                                               scramble: "scramble",
                                                               isPreinspectionOn: true)
    static let timerStatePreinspectionReady = TimerViewState(cubingState: .preinspectionReady,
                                                             time: 4.0,
                                                             cube: .three,
                                                             scramble: "scramble",
                                                             isPreinspectionOn: true)
    static let timerStateOngoing = TimerViewState(cubingState: .ongoing,
                                                  time: 5.3,
                                                  cube: .three,
                                                  scramble: "scramble",
                                                  isPreinspectionOn: false)
    static let timerStateEnded = TimerViewState(cubingState: .ended,
                                                time: 5.3,
                                                cube: .three,
                                                scramble: "scramble",
                                                isPreinspectionOn: false)
    static let timerStatePresentingOverlay =  TimerViewState(cubingState: .ended,
                                                             time: 5.3,
                                                             cube: .three,
                                                             scramble: "scramble",
                                                             isPreinspectionOn: false)
}
