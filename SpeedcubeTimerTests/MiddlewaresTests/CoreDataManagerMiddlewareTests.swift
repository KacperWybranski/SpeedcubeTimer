//
//  CoreDataManagerMiddlewareTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 30/09/2022.
//

import Foundation
import XCTest
import Combine

final class CoreDataManagerMiddlewareTests: XCTestCase {
    private var dataController: TestDataController?
    private var coreDataManager: Middleware<AppState>?
    private var subscriptions: [UUID: AnyCancellable] = [:]
    
    override func setUp() {
        let dataController = TestDataController()
        self.dataController = dataController
        self.coreDataManager = Middlewares.coreDataManager(with: dataController)
    }
    
    func testLoadSessions() {
        
        // Input
        
        let expectation1 = XCTestExpectation(description: "on receive value")
        let expectation2 = XCTestExpectation(description: "on receive newSessionsSet")
        
        dataController?.sessionsToLoad = TestConfiguration.sessions
        let initialSession = CubingSession.initialSession
        let beforeState = AppState(allSessions: [initialSession],
                                   currentSession: initialSession,
                                   screens: [
                                    .timerScreen(TimerViewState(session: initialSession)),
                                    .resultsScreen(ResultsViewState(currentSession: initialSession)),
                                    .settingsScreen(SettingsViewState(allSessions: [initialSession]))
                                   ])
        
        // On Action
        
        let onReceiveValue: ((Action) -> Void) = { action in
            expectation1.fulfill()
            
            if case AppStateAction.newSessionsSet(let previous, let current, let all) = action {
                expectation2.fulfill()
                XCTAssertEqual(previous, initialSession)
                XCTAssertEqual(current, initialSession)
                XCTAssertEqual(all, TestConfiguration.sessions)
            }
        }
        
        // Perform
        
        let key = UUID()
        
        coreDataManager?(
            beforeState,
            AppStateAction.loadSessions
        )
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { [weak self] _ in
            self?.subscriptions.removeValue(forKey: key)
        }, receiveValue: { action in
            onReceiveValue(action)
        })
        .store(in: &subscriptions, key: key)
        
        wait(for: [expectation1, expectation2], timeout: 5.0)
    }
    
    func testSaveResult() {
        
        // Input
        
        let expectation1 = XCTestExpectation(description: "on receive value")
        let expectation2 = XCTestExpectation(description: "on action recognized")
        let expectation3 = XCTestExpectation(description: "on save")
        
        let initialSession = CubingSession.initialSession
        let beforeState = AppState(allSessions: [initialSession],
                                   currentSession: initialSession,
                                   screens: [
                                    .timerScreen(TimerViewState(session: initialSession)),
                                    .resultsScreen(ResultsViewState(currentSession: initialSession)),
                                    .settingsScreen(SettingsViewState (allSessions: [initialSession]))
                                   ])
        let newResult = Result(time: 8.0, scramble: "scramble", date: Date())
        
        // On action
        
        dataController?.onSave = { result, session in
            expectation3.fulfill()
            XCTAssertEqual(session, initialSession)
            XCTAssertEqual(result, newResult)
            
        }
        
        let onReceiveValue: ((Action) -> Void) = { action in
            expectation1.fulfill()
            if case AppStateAction.loadSessions = action {
                expectation2.fulfill()
            }
        }
        
        // Perform
        
        let key = UUID()
        
        coreDataManager?(
            beforeState,
            TimerViewStateAction.saveResult(newResult)
        )
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { [weak self] _ in
            self?.subscriptions.removeValue(forKey: key)
        }, receiveValue: { action in
            onReceiveValue(action)
        })
        .store(in: &subscriptions, key: key)
        
        wait(for: [expectation1, expectation3], timeout: 5.0)
    }
    
    func testRemoveResults() {
        // Input
        
        let expectation1 = XCTestExpectation(description: "on receive value")
        let expectation2 = XCTestExpectation(description: "on action recognized")
        let expectation3 = XCTestExpectation(description: "on remove")
        
        let initialSession = TestConfiguration.sessions.first!
        let beforeState = AppState(allSessions: [initialSession],
                                   currentSession: initialSession,
                                   screens: [
                                    .timerScreen(TimerViewState(session: initialSession)),
                                    .resultsScreen(ResultsViewState(currentSession: initialSession)),
                                    .settingsScreen(SettingsViewState (allSessions: [initialSession]))
                                   ])
        
        // On action
        
        dataController?.onRemove = { result, session in
            expectation3.fulfill()
            XCTAssertEqual(session, initialSession)
            XCTAssertEqual(result, initialSession.results.first)
            
        }
        
        let onReceiveValue: ((Action) -> Void) = { action in
            expectation1.fulfill()
            if case AppStateAction.loadSessions = action {
                expectation2.fulfill()
            }
        }
        
        // Perform
        
        let key = UUID()
        
        coreDataManager?(
            beforeState,
            ResultsViewStateAction.removeResultsAt(IndexSet(integer: 0))
        )
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { [weak self] _ in
            self?.subscriptions.removeValue(forKey: key)
        }, receiveValue: { action in
            onReceiveValue(action)
        })
        .store(in: &subscriptions, key: key)
        
        wait(for: [expectation1, expectation3], timeout: 5.0)
    }
    
    func testNameChanged() {
        // Input
        
        let expectation1 = XCTestExpectation(description: "on receive value")
        let expectation2 = XCTestExpectation(description: "on action recognized")
        let expectation3 = XCTestExpectation(description: "on name change")
        
        let initialSession = TestConfiguration.sessions.first!
        let beforeState = AppState(allSessions: [initialSession],
                                   currentSession: initialSession,
                                   screens: [
                                    .timerScreen(TimerViewState(session: initialSession)),
                                    .resultsScreen(ResultsViewState(currentSession: initialSession)),
                                    .settingsScreen(SettingsViewState (allSessions: [initialSession]))
                                   ])
        
        // On action
        
        dataController?.onChangeName = { session, name in
            expectation3.fulfill()
            XCTAssertEqual(session, initialSession)
            XCTAssertEqual(name, TestConfiguration.sessionName)
            
        }
        
        let onReceiveValue: ((Action) -> Void) = { action in
            expectation1.fulfill()
            if case AppStateAction.loadSessions = action {
                expectation2.fulfill()
            }
        }
        
        // Perform
        
        let key = UUID()
        
        coreDataManager?(
            beforeState,
            SettingsViewStateAction.currentSessionNameChanged(TestConfiguration.sessionName)
        )
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { [weak self] _ in
            self?.subscriptions.removeValue(forKey: key)
        }, receiveValue: { action in
            onReceiveValue(action)
        })
        .store(in: &subscriptions, key: key)
        
        wait(for: [expectation1, expectation3], timeout: 5.0)
    }
    
    func testErase() {
        // Input
        
        let expectation1 = XCTestExpectation(description: "on receive value")
        let expectation2 = XCTestExpectation(description: "on action recognized")
        let expectation3 = XCTestExpectation(description: "on erase")
        
        let initialSession = TestConfiguration.sessions.first!
        let beforeState = AppState(allSessions: [initialSession],
                                   currentSession: initialSession,
                                   screens: [
                                    .timerScreen(TimerViewState(session: initialSession)),
                                    .resultsScreen(ResultsViewState(currentSession: initialSession)),
                                    .settingsScreen(SettingsViewState (allSessions: [initialSession]))
                                   ])
        
        // On action
        
        dataController?.onErase = { session in
            expectation3.fulfill()
            XCTAssertEqual(session, initialSession)
            
        }
        
        let onReceiveValue: ((Action) -> Void) = { action in
            expectation1.fulfill()
            if case AppStateAction.loadSessions = action {
                expectation2.fulfill()
            }
        }
        
        // Perform
        
        let key = UUID()
        
        coreDataManager?(
            beforeState,
            SettingsViewStateAction.eraseSession(initialSession)
        )
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { [weak self] _ in
            self?.subscriptions.removeValue(forKey: key)
        }, receiveValue: { action in
            onReceiveValue(action)
        })
        .store(in: &subscriptions, key: key)
        
        wait(for: [expectation1, expectation3], timeout: 5.0)
    }
    
    func testResetApp() {
        // Input
        
        let expectation1 = XCTestExpectation(description: "on receive value")
        let expectation2 = XCTestExpectation(description: "on action recognized")
        let expectation3 = XCTestExpectation(description: "on reset")
        
        let initialSession = TestConfiguration.sessions.first!
        let beforeState = AppState(allSessions: [initialSession],
                                   currentSession: initialSession,
                                   screens: [
                                    .timerScreen(TimerViewState(session: initialSession)),
                                    .resultsScreen(ResultsViewState(currentSession: initialSession)),
                                    .settingsScreen(SettingsViewState (allSessions: [initialSession]))
                                   ])
        
        // On action
        
        dataController?.onReset = {
            expectation3.fulfill()
        }
        
        let onReceiveValue: ((Action) -> Void) = { action in
            expectation1.fulfill()
            if case AppStateAction.loadSessions = action {
                expectation2.fulfill()
            }
        }
        
        // Perform
        
        let key = UUID()
        
        coreDataManager?(
            beforeState,
            SettingsViewStateAction.resetApp
        )
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { [weak self] _ in
            self?.subscriptions.removeValue(forKey: key)
        }, receiveValue: { action in
            onReceiveValue(action)
        })
        .store(in: &subscriptions, key: key)
        
        wait(for: [expectation1, expectation3], timeout: 5.0)
    }
}

final class TestDataController: DataControllerProtocol {
    
    // MARK: - Properties
    
    var sessionsToLoad: [CubingSession] = []
    var onSave: ((Result, CubingSession) -> Void)?
    var onRemove: ((Result, CubingSession) -> Void)?
    var onErase: ((CubingSession) -> Void)?
    var onReset: (() -> Void)?
    var onChangeName: ((CubingSession, String?) -> Void)?
    
    // MARK: - DataControllerProtocol
    
    func loadSessions() -> [CubingSession] {
        sessionsToLoad
    }
    
    func save(_ result: Result, to session: CubingSession) {
        onSave?(result, session)
    }
    
    func remove(result: Result, from session: CubingSession) {
        onRemove?(result, session)
    }
    
    func erase(session: CubingSession) {
        onErase?(session)
    }
    
    func reset() {
        onReset?()
    }
    
    func changeName(of session: CubingSession, to name: String?) {
        onChangeName?(session, name)
    }
}

private enum TestConfiguration {
    static let sessions: [CubingSession] = [
        .init(
            results: [
                Result(time: 43.0,
                       scramble: "abc",
                       date: Date())],
            cube: .four,
            index: 3,
            name: "Hello"
        ),
        .init(
            results: [
                Result(time: 74.0,
                       scramble: "sws",
                       date: Date()),
                Result(time: 1.0,
                       scramble: "fdd",
                       date: Date())],
            cube: .four,
            index: 3
        )
    ]
    static let sessionName = "Test name"
}
