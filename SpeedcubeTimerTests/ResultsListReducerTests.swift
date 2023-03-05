//
//  ResultsListReducerTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 17/12/2022.
//

import Foundation
import XCTest
import ComposableArchitecture
@testable import SpeedcubeTimer

final class ResultsListReducerTests: XCTestCase {
    
    var sessionManager: MockSessionsManager!
    
    override func setUp() async throws {
        sessionManager = MockSessionsManager()
    }
    
    @MainActor
    func testLoadSessions() async {
        let store = TestStore(
            initialState: ResultsListFeature.State(),
            reducer: ResultsListFeature(
                sessionsManager: sessionManager,
                calculationsPriority: .high
            )
        )
        
        sessionManager.sessionsSource = {
            return ([Configuration.session], Configuration.session)
        }
        
        _ = await store.send(.loadSession)
        
        await store.receive(.sessionLoaded(Configuration.session)) { state in
            state.currentSession = Configuration.session
        }
        
        await store.receive(.calculateResults(Configuration.session))
        
        await store.receive(.resultsCalculated(Configuration.calculatedState)) { state in
            state = Configuration.calculatedState
        }
    }
    
    @MainActor
    func testRemoveResultsAt() async {
        let expectation = XCTestExpectation(description: "on remove called")
        
        let store = TestStore(
            initialState: ResultsListFeature.State(),
            reducer: ResultsListFeature(
                sessionsManager: sessionManager,
                calculationsPriority: .high
            )
        )
        
        sessionManager.sessionsSource = {
            return ([Configuration.session], Configuration.session)
        }
        
        sessionManager.onRemoveResults = { indexSet in
            expectation.fulfill()
            XCTAssertEqual(indexSet, Configuration.indexSet)
        }
        
        _ = await store.send(.removeResultsAt(Configuration.indexSet))
        
        await store.receive(.loadSession)
        
        // below can be removed in future
        
        await store.receive(.sessionLoaded(Configuration.session)) { state in
            state.currentSession = Configuration.session
        }
        
        await store.receive(.calculateResults(Configuration.session))
        
        await store.receive(.resultsCalculated(Configuration.calculatedState)) { state in
            state = Configuration.calculatedState
        }
        
        wait(for: [expectation], timeout: 5.0)
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
    
    static var calculatedState: ResultsListFeature.State {
        .init(
            currentSession: session,
            currentAvg5: session.avgOfLast(5),
            currentAvg12: session.avgOfLast(12),
            currentMean100: session.meanOfLast(100),
            bestResult: session.bestResult,
            bestAvg5: session.bestAvgOf(5, mode: .avgOf),
            bestAvg12: session.bestAvgOf(12, mode: .avgOf),
            bestMean100: session.bestAvgOf(100, mode: .meanOf)
        )
    }
    
    static var indexSet: IndexSet = .init(integer: 0)
}
