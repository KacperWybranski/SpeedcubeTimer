//
//  SettingsViewStateReducerTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 02/09/2022.
//

import XCTest

final class SettingsViewStateReducerTests: XCTestCase {
    
    func testNewAllSessionSet() {
        
        // Input
        
        let beforeSessions = Configuration.sampleSessions
        let afterSessions = Configuration.sampleSessions2
        let beforeState = SettingsViewState(allSessions: beforeSessions)
        let afterState = SettingsViewState(allSessions: afterSessions)
        
        // Reduce
        
        let reduced = SettingsViewState
                            .reducer(
                                beforeState,
                                AppStateAction
                                    .newSessionsSet(
                                        previous: beforeSessions.first!,
                                        current: afterSessions.first!,
                                        allSessions: afterSessions)
                            )
        
        // Test
        
        XCTAssertEqual(afterState, reduced)
    }
    
    func testIsPreinspectionOnChanged() {
        
        // Input
        
        let session = CubingSession()
        let beforeState = SettingsViewState(allSessions: [session],
                                            currentSession: session,
                                            isPreinspectionOn: false,
                                            isPresentingEraseSessionPopup: false,
                                            isPresentingResetActionSheet: false,
                                            isPresentingResetAppPopup: false)
        let afterState = SettingsViewState(allSessions: [session],
                                           currentSession: session,
                                           isPreinspectionOn: true,
                                           isPresentingEraseSessionPopup: false,
                                           isPresentingResetActionSheet: false,
                                           isPresentingResetAppPopup: false)
        
        // Reduce
        
        let reduced = SettingsViewState.reducer(beforeState, SettingsViewStateAction.isPreinspectionOnChanged(true))
        
        // Test
        
        XCTAssertEqual(afterState, reduced)
    }
    
    func testShowEraseSessionPopup() {
        
        // Input
        
        let session = CubingSession()
        let beforeState = SettingsViewState(allSessions: [session],
                                            currentSession: session,
                                            isPreinspectionOn: false,
                                            isPresentingEraseSessionPopup: false,
                                            isPresentingResetActionSheet: false,
                                            isPresentingResetAppPopup: false)
        let afterState = SettingsViewState(allSessions: [session],
                                           currentSession: session,
                                           isPreinspectionOn: false,
                                           isPresentingEraseSessionPopup: true,
                                           isPresentingResetActionSheet: false,
                                           isPresentingResetAppPopup: false)
        
        // Reduce
        
        let reduced = SettingsViewState.reducer(beforeState, SettingsViewStateAction.showEraseSessionPopup(true))
        
        // Test
        
        XCTAssertEqual(afterState, reduced)
    }
    
    func testShowResetActionSheet() {
        
        // Input
        
        let session = CubingSession()
        let beforeState = SettingsViewState(allSessions: [session],
                                            currentSession: session,
                                            isPreinspectionOn: false,
                                            isPresentingEraseSessionPopup: false,
                                            isPresentingResetActionSheet: false,
                                            isPresentingResetAppPopup: false)
        let afterState = SettingsViewState(allSessions: [session],
                                           currentSession: session,
                                           isPreinspectionOn: false,
                                           isPresentingEraseSessionPopup: false,
                                           isPresentingResetActionSheet: true,
                                           isPresentingResetAppPopup: false)
        
        // Reduce
        
        let reduced = SettingsViewState.reducer(beforeState, SettingsViewStateAction.showResetActionSheet(true))
        
        // Test
        
        XCTAssertEqual(afterState, reduced)
    }
    
    func testShowResetAppPopup() {
        
        // Input
        
        let session = CubingSession()
        let beforeState = SettingsViewState(allSessions: [session],
                                            currentSession: session,
                                            isPreinspectionOn: false,
                                            isPresentingEraseSessionPopup: false,
                                            isPresentingResetActionSheet: false,
                                            isPresentingResetAppPopup: false)
        let afterState = SettingsViewState(allSessions: [session],
                                           currentSession: session,
                                           isPreinspectionOn: false,
                                           isPresentingEraseSessionPopup: false,
                                           isPresentingResetActionSheet: false,
                                           isPresentingResetAppPopup: true)
        
        // Reduce
        
        let reduced = SettingsViewState.reducer(beforeState, SettingsViewStateAction.showResetAppPopup(true))
        
        // Test
        
        XCTAssertEqual(afterState, reduced)
    }
    
    func testNonHandledAction() {
        
        // Input
        
        let session = CubingSession()
        let beforeState = SettingsViewState(allSessions: [session],
                                            currentSession: session,
                                            isPreinspectionOn: false,
                                            isPresentingEraseSessionPopup: false,
                                            isPresentingResetActionSheet: false,
                                            isPresentingResetAppPopup: false)
        
        // Reduced
        
        let reduced = SettingsViewState.reducer(beforeState, TestAction.notHandledAction)
        
        // Test
        
        XCTAssertEqual(beforeState, reduced)
    }
}

private enum Configuration {
    static let sampleSessions: [CubingSession] = [
        .init(results: [], cube: .three, index: 1),
        .init(results: [], cube: .three, index: 5),
        .init(results: [], cube: .two, index: 2)
    ]
    static let sampleSessions2: [CubingSession] = [
        .init(results: [], cube: .four, index: 1),
        .init(results: [], cube: .four, index: 9)
    ]
}
