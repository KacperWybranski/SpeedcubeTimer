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
    
    func testNewSessionsSet() {
        
        // Input
        
        let session1 = Configuration.sessionCubeThreeIndexOne
        let session2 = Configuration.sessionCubeTwoIndexOne
        let session3 = Configuration.sessionCubeTwoIndexOne
        let beforeAppState = AppState(allSessions: [session1],
                                      currentSession: session1,
                                      screens: [.settingsScreen(SettingsViewState(allSessions: [session1],
                                                                                  currentSession: session1,
                                                                                  isPreinspectionOn: false,
                                                                                  isPresentingEraseSessionPopup: false,
                                                                                  isPresentingResetActionSheet: false,
                                                                                  isPresentingResetAppPopup: false)),
                                                .timerScreen(TimerViewState(session: session1)),
                                                .resultsScreen(ResultsViewState(currentSession: session1))])
        
        let afterAppState = AppState(allSessions: [session3],
                                     currentSession: session3,
                                     screens: [.settingsScreen(SettingsViewState(allSessions: [session3],
                                                                                 currentSession: session3,
                                                                                 isPreinspectionOn: false,
                                                                                 isPresentingEraseSessionPopup: false,
                                                                                 isPresentingResetActionSheet: false,
                                                                                 isPresentingResetAppPopup: false)),
                                               .timerScreen(TimerViewState(session: session3)),
                                               .resultsScreen(ResultsViewState(currentSession: session3))])
        
        // Reduce
        
        let reduced = AppState.reducer(beforeAppState, AppStateAction.newSessionsSet(current: session3, allSessions: [session3]))
        
        // Test
        
        XCTAssertEqual(reduced.allSessions, afterAppState.allSessions)
        XCTAssertEqual(reduced.currentSession, afterAppState.currentSession)
        
        for (screen, screenReduced) in zip(afterAppState.screens, reduced.screens) {
            switch (screen, screenReduced) {
            case (.timerScreen(let state), .timerScreen(let stateReduced)):
                XCTAssertEqual(state.cube, stateReduced.cube)
            case (.resultsScreen(let state), .resultsScreen(let stateReduced)):
                XCTAssertEqual(state, stateReduced)
            case (.settingsScreen(let state), .settingsScreen(let stateReduced)):
                XCTAssertEqual(state, stateReduced)
            default:
                break
            }
        }
    }
    
    func testNonHandledAction() {
        
        // Input
        
        let sessionBefore = Configuration.sessionCubeThreeIndexOneWithOneSolve
        let beforeAppState = AppState(allSessions: [sessionBefore],
                                      currentSession: sessionBefore,
                                      screens: [.main(MainViewState()),
                                                .timerScreen(TimerViewState(session: sessionBefore)),
                                                .resultsScreen(ResultsViewState(currentSession: sessionBefore)),
                                                .settingsScreen(SettingsViewState(allSessions: [sessionBefore]))])
        
        // Reduced
        
        let reduced = AppState.reducer(beforeAppState, TestAction.notHandledAction)
        
        // Test
        
        XCTAssertEqual(beforeAppState.allSessions, reduced.allSessions)
        XCTAssertEqual(beforeAppState.currentSession, reduced.currentSession)
        
        for (screen, screenReduced) in zip(beforeAppState.screens, reduced.screens) {
            switch (screen, screenReduced) {
            case (.timerScreen(let state), .timerScreen(let stateReduced)):
                XCTAssertEqual(state.cube, stateReduced.cube)
            case (.resultsScreen(let state), .resultsScreen(let stateReduced)):
                XCTAssertEqual(state.currentSession, stateReduced.currentSession)
            case (.settingsScreen(let state), .settingsScreen(let stateReduced)):
                XCTAssertEqual(state.allSessions, stateReduced.allSessions)
            case (.main(let state), .main(let stateReduced)):
                XCTAssertEqual(state, stateReduced)
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
