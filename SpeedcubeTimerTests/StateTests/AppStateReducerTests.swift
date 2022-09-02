//
//  AppStateReducerTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 20/08/2022.
//

import XCTest

class AppStateReducerTests: XCTestCase {
    
    override func setUpWithError() throws { }
    
    override func tearDownWithError() throws { }
    
    func testCubeChangedOnSettingsScreen() {
        
        // Input
        
        let session1 = Configuration.sessionCubeThreeIndexOne
        let session2 = Configuration.sessionCubeTwoIndexOne
        let beforeAppState = AppState(allSessions: [session1, session2],
                                      currentSession: session1,
                                      screens: [.timerScreen(TimerViewState(session: session1)),
                                                .resultsScreen(ResultsViewState(currentSession: session1))])
        
        let afterAppState = AppState(allSessions: [session1, session2],
                                     currentSession: session2,
                                     screens: [.timerScreen(TimerViewState(session: session2)),
                                               .resultsScreen(ResultsViewState(currentSession: session2))])
        
        // Reduce
        
        let reduced = AppState.reducer(beforeAppState, SettingsViewStateAction.cubeChanged(.two))
        
        // Test
        
        XCTAssertEqual(reduced.allSessions, afterAppState.allSessions)
        XCTAssertEqual(reduced.currentSession, afterAppState.currentSession)
        
        for (screen, screenReduced) in zip(afterAppState.screens, reduced.screens) {
            switch (screen, screenReduced) {
            case (.timerScreen(let state), .timerScreen(let stateReduced)):
                XCTAssertEqual(state.cube, stateReduced.cube)
            case (.resultsScreen(let state), .resultsScreen(let stateReduced)):
                XCTAssertEqual(state.currentSession, stateReduced.currentSession)
            default:
                break
            }
        }
    }
    
    func testSessionIndexChangedOnSettingsScreen() {
        
        // Input
        
        let session1 = Configuration.sessionCubeThreeIndexOne
        let session2 = Configuration.sessionCubeThreeIndexTwo
        let beforeAppState = AppState(allSessions: [session1, session2],
                                      currentSession: session1,
                                      screens: [.timerScreen(TimerViewState(session: session1)),
                                                .resultsScreen(ResultsViewState(currentSession: session1))])
        
        let afterAppState = AppState(allSessions: [session1, session2],
                                     currentSession: session2,
                                     screens: [.timerScreen(TimerViewState(session: session2)),
                                               .resultsScreen(ResultsViewState(currentSession: session2))])
        
        // Reduce
        
        let reduced = AppState.reducer(beforeAppState, SettingsViewStateAction.sessionIndexChanged(2))
        
        // Test
        
        XCTAssertEqual(reduced.allSessions, afterAppState.allSessions)
        XCTAssertEqual(reduced.currentSession, afterAppState.currentSession)
        
        for (screen, screenReduced) in zip(afterAppState.screens, reduced.screens) {
            switch (screen, screenReduced) {
            case (.timerScreen(let state), .timerScreen(let stateReduced)):
                XCTAssertEqual(state.cube, stateReduced.cube)
            case (.resultsScreen(let state), .resultsScreen(let stateReduced)):
                XCTAssertEqual(state.currentSession, stateReduced.currentSession)
            default:
                break
            }
        }
    }
    
    func testSaveNewResultOnTimerScreen() {
        
        // Input
        
        let sessionBefore = Configuration.sessionCubeThreeIndexOneWithoutSolve
        let sessionAfter = Configuration.sessionCubeThreeIndexOneWithOneSolve
        let beforeAppState = AppState(allSessions: [sessionBefore],
                                      currentSession: sessionBefore,
                                      screens: [.timerScreen(TimerViewState(session: sessionBefore)),
                                                .resultsScreen(ResultsViewState(currentSession: sessionBefore))])
        
        let afterAppState = AppState(allSessions: [sessionAfter],
                                     currentSession: sessionAfter,
                                     screens: [.timerScreen(TimerViewState(session: sessionAfter)),
                                               .resultsScreen(ResultsViewState(currentSession: sessionAfter))])
        
        // Reduce
        
        let reduced = AppState.reducer(beforeAppState, TimerViewStateAction.saveResult(Configuration.sampleSolve))
        
        // Test
        
        XCTAssertEqual(reduced.allSessions, afterAppState.allSessions)
        XCTAssertEqual(reduced.currentSession, afterAppState.currentSession)
        
        for (screen, screenReduced) in zip(afterAppState.screens, reduced.screens) {
            switch (screen, screenReduced) {
            case (.timerScreen(let state), .timerScreen(let stateReduced)):
                XCTAssertEqual(state.cube, stateReduced.cube)
            case (.resultsScreen(let state), .resultsScreen(let stateReduced)):
                XCTAssertEqual(state.currentSession, stateReduced.currentSession)
            default:
                break
            }
        }
    }
    
    func testRemoveResultOnResultsListScreen() {
        
        // Input
        
        let sessionBefore = Configuration.sessionCubeThreeIndexOneWithOneSolve
        let sessionAfter = Configuration.sessionCubeThreeIndexOneWithoutSolve
        let beforeAppState = AppState(allSessions: [sessionBefore],
                                      currentSession: sessionBefore,
                                      screens: [.timerScreen(TimerViewState(session: sessionBefore)),
                                                .resultsScreen(ResultsViewState(currentSession: sessionBefore))])
        
        let afterAppState = AppState(allSessions: [sessionAfter],
                                     currentSession: sessionAfter,
                                     screens: [.timerScreen(TimerViewState(session: sessionAfter)),
                                               .resultsScreen(ResultsViewState(currentSession: sessionAfter))])
        
        // Reduce
        
        let reduced = AppState.reducer(beforeAppState, ResultsViewStateAction.removeResultsAt(.init(integer: 0)))
        
        // Test
        
        XCTAssertEqual(reduced.allSessions, afterAppState.allSessions)
        XCTAssertEqual(reduced.currentSession, afterAppState.currentSession)
        
        for (screen, screenReduced) in zip(afterAppState.screens, reduced.screens) {
            switch (screen, screenReduced) {
            case (.timerScreen(let state), .timerScreen(let stateReduced)):
                XCTAssertEqual(state.cube, stateReduced.cube)
            case (.resultsScreen(let state), .resultsScreen(let stateReduced)):
                XCTAssertEqual(state.currentSession, stateReduced.currentSession)
            default:
                break
            }
        }
    }
    
    func testCurrentSessionNameChanged() {
        
        // Input
        
        let sessionBefore = Configuration.sessionCubeThreeIndexOneWithOneSolve
        let sessionAfter = Configuration.sessionCubeThreeIndexOneWithOneSolveAndName
        let beforeAppState = AppState(allSessions: [sessionBefore],
                                      currentSession: sessionBefore,
                                      screens: [.timerScreen(TimerViewState(session: sessionBefore)),
                                                .resultsScreen(ResultsViewState(currentSession: sessionBefore)),
                                                .settingsScreen(SettingsViewState(allSessions: [sessionBefore]))])
        
        let afterAppState = AppState(allSessions: [sessionAfter],
                                     currentSession: sessionAfter,
                                     screens: [.timerScreen(TimerViewState(session: sessionAfter)),
                                               .resultsScreen(ResultsViewState(currentSession: sessionAfter)),
                                               .settingsScreen(SettingsViewState(allSessions: [sessionAfter]))])
        
        // Reduce
        
        let reduced = AppState.reducer(beforeAppState, SettingsViewStateAction.currentSessionNameChanged(Configuration.sampleName))
        
        // Test
        
        XCTAssertEqual(afterAppState.allSessions, reduced.allSessions)
        XCTAssertEqual(afterAppState.currentSession, reduced.currentSession)
        
        for (screen, screenReduced) in zip(afterAppState.screens, reduced.screens) {
            switch (screen, screenReduced) {
            case (.timerScreen(let state), .timerScreen(let stateReduced)):
                XCTAssertEqual(state.cube, stateReduced.cube)
            case (.resultsScreen(let state), .resultsScreen(let stateReduced)):
                XCTAssertEqual(state.currentSession, stateReduced.currentSession)
            case (.settingsScreen(let state), .settingsScreen(let stateReduced)):
                XCTAssertEqual(state.allSessions, stateReduced.allSessions)
            default:
                break
            }
        }
    }
    
}

private enum Configuration {
    static let sessionCubeThreeIndexOne = CubingSession(results: [], cube: .three, index: 1)
    static let sessionCubeThreeIndexTwo = CubingSession(results: [], cube: .three, index: 2)
    static let sessionCubeTwoIndexOne = CubingSession(results: [], cube: .two, index: 1)
    
    static let sampleSolve: Result = .init(time: 5.0, scramble: "scramble", date: Date())
    static let sampleUUID = UUID()
    static let sampleName = "One handed"
    static let sessionCubeThreeIndexOneWithoutSolve = CubingSession(results: [],
                                                                    cube: .three,
                                                                    index: 1,
                                                                    id: sampleUUID)
    static let sessionCubeThreeIndexOneWithOneSolve = CubingSession(results: [sampleSolve],
                                                                    cube: .three,
                                                                    index: 1,
                                                                    id: sampleUUID)
    static let sessionCubeThreeIndexOneWithOneSolveAndName = CubingSession(results: [sampleSolve],
                                                                           cube: .three,
                                                                           index: 1,
                                                                           name: sampleName,
                                                                           id: sampleUUID)
}
