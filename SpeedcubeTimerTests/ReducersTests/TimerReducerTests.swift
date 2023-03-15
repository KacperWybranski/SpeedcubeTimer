//
//  TimerReducerTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 06/03/2023.
//

import Foundation
import XCTest
import ComposableArchitecture
@testable import SpeedcubeTimer

final class TimerReducerTests: XCTestCase {
    var sessionManager: MockSessionsManager!
    var userSettings: UserSettingsProtocol!
    
    override func setUp() async throws {
        sessionManager = MockSessionsManager()
        userSettings = UserSettings()
    }
    
    @MainActor
    func testLoadSession() async {
        let store = TestStore(
            initialState: TimerFeature.State(),
            reducer: TimerFeature(
                mainQueue: .immediate,
                overlayCheckPriority: .userInitiated,
                sessionsManager: sessionManager,
                userSettings: userSettings
            )
        )
        store.exhaustivity = .off
        
        sessionManager.sessionsSource = {
            return ([Configuration.session], Configuration.session)
        }
        
        _ = await store.send(.loadSession)
        
        await store.receive(.sessionLoaded(Configuration.session)) { state in
            state.cube = Configuration.session.cube
        }
    }
    
    @MainActor
    func testSaveResultWithoutRecord() async {
        let store = TestStore(
            initialState: TimerFeature.State(),
            reducer: TimerFeature(
                mainQueue: .immediate,
                overlayCheckPriority: .userInitiated,
                sessionsManager: sessionManager,
                userSettings: userSettings
            )
        )
        
        sessionManager.checkForPbResult = Configuration.checkForPbNoneResult
        
        _ = await store.send(.saveResult(Configuration.result))
        
        await store.receive(.newRecordSet(Configuration.checkForPbNoneResult))
    }
    
    @MainActor
    func testSaveResultWithRecord() async {
        let store = TestStore(
            initialState: TimerFeature.State(),
            reducer: TimerFeature(
                mainQueue: .immediate,
                overlayCheckPriority: .userInitiated,
                sessionsManager: sessionManager,
                userSettings: userSettings
            )
        )
        
        sessionManager.checkForPbResult = Configuration.checkForPbAvg5Result
        
        _ = await store.send(.saveResult(Configuration.result))
        
        await store.receive(.newRecordSet(Configuration.checkForPbAvg5Result))
    }
    
    @MainActor
    func testSolvingProcess() async {
        let store = TestStore(
            initialState: TimerFeature.State(
                cubingState: .idle,
                time: 0.0,
                cube: .three,
                scramble: .empty,
                alert: nil
            ),
            reducer: TimerFeature(
                mainQueue: .immediate,
                overlayCheckPriority: .userInitiated,
                sessionsManager: sessionManager,
                userSettings: userSettings
            )
        )
        store.exhaustivity = .off
        
        _ = await store.send(.touchBegan) {
            $0.cubingState = .ready
        }
        
        _ = await store.send(.touchEnded) {
            $0.cubingState = .ongoing
        }
        
        _ = await store.send(.touchBegan) {
            $0.cubingState = .ended
        }
        
        _ = await store.send(.touchEnded) {
            $0.cubingState = .idle
        }
    }
    
    @MainActor
    func testSolvingProcessWithPreinspection() async {
        let store = TestStore(
            initialState: TimerFeature.State(
                cubingState: .idle,
                time: 0.0,
                cube: .three,
                scramble: .empty,
                alert: nil
            ),
            reducer: TimerFeature(
                mainQueue: .immediate,
                overlayCheckPriority: .userInitiated,
                sessionsManager: sessionManager,
                userSettings: userSettings
            )
        )
        store.exhaustivity = .off
        
        userSettings.setIsPreinspectionOn(true)
        
        _ = await store.send(.touchBegan) {
            $0.cubingState = .ready
        }
        
        _ = await store.send(.touchEnded) {
            $0.cubingState = .preinspectionOngoing
        }
        
        _ = await store.send(.touchBegan) {
            $0.cubingState = .preinspectionReady
        }
        
        _ = await store.send(.touchEnded) {
            $0.cubingState = .ongoing
        }
        
        _ = await store.send(.touchBegan) {
            $0.cubingState = .ended
        }
        
        _ = await store.send(.touchEnded) {
            $0.cubingState = .idle
        }
    }
}

private enum Configuration {
    static var session: CubingSession = .init(
        results: [.init(time: 3.0, scramble: "scramble", date: Date())],
        cube: .four,
        index: 3,
        name: nil,
        id: .init()
    )
    
    static var result: Result = .init(
        time: 2.0,
        scramble: "scramble",
        date: Date()
    )
    
    static var checkForPbAvg5Result: OverlayManager.RecordType = .avg5
    static var checkForPbNoneResult: OverlayManager.RecordType = .none
}
