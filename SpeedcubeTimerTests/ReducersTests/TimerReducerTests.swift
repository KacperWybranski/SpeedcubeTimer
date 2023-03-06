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
        
        sessionManager.sessionsSource = {
            return ([Configuration.session], Configuration.session)
        }
        
        _ = await store.send(.loadSession)
        
        await store.receive(.sessionLoaded(Configuration.session)) { state in
            state.cube = Configuration.session.cube
            // must be exactly the same state - to fix
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
}
