//
//  OverlayManagerTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 16/11/2022.
//

import XCTest
import SpeedcubeTimer

final class OverlayManagerTests: XCTestCase {
    
    let manager: OverlayManager = OverlayManager()
    
    func testNoRecord() {
        
        let oldSession = CubingSession(
            results: Configuration.results,
            cube: .three,
            index: 1
        )
        let newSession = CubingSession(
            results: Configuration.resultsWorse,
            cube: .three,
            index: 1
        )
        
        XCTAssertEqual(
            manager
                .checkForNewRecord(
                    oldSession: oldSession,
                    newSession: newSession
                ),
            OverlayManager.RecordType.none
        )
    }
    
    func testSingleRecord() {
        
        let oldSession = CubingSession(
            results: Configuration.results,
            cube: .three,
            index: 1
        )
        let newSession = CubingSession(
            results: Configuration.resultsBetterSingle,
            cube: .three,
            index: 1
        )
        
        XCTAssertEqual(
            manager
                .checkForNewRecord(
                    oldSession: oldSession,
                    newSession: newSession
                ),
            OverlayManager.RecordType.single
        )
    }
    
    func testAvg5Record() {
        
        let oldSession = CubingSession(
            results: Configuration.results,
            cube: .three,
            index: 1
        )
        let newSession = CubingSession(
            results: Configuration.resultsBetterAvg5,
            cube: .three,
            index: 1
        )
        
        XCTAssertEqual(
            manager
                .checkForNewRecord(
                    oldSession: oldSession,
                    newSession: newSession
                ),
            OverlayManager.RecordType.avg5
        )
    }
    
    func testAvg12Record() {
        
        let oldSession = CubingSession(
            results: Configuration.resultsBetterAvg5,
            cube: .three,
            index: 1
        )
        let newSession = CubingSession(
            results: Configuration.resultsBetterAvg12,
            cube: .three,
            index: 1
        )
        
        XCTAssertEqual(
            manager
                .checkForNewRecord(
                    oldSession: oldSession,
                    newSession: newSession
                ),
            OverlayManager.RecordType.avg12
        )
    }
    
    func testMo100Record() {
        
        let oldSession = CubingSession(
            results: Configuration.resultsBetterAvg12,
            cube: .three,
            index: 1
        )
        let newSession = CubingSession(
            results: Configuration.resultsBetterMo100,
            cube: .three,
            index: 1
        )
        
        XCTAssertEqual(
            manager
                .checkForNewRecord(
                    oldSession: oldSession,
                    newSession: newSession
                ),
            OverlayManager.RecordType.mo100
        )
    }
}

private enum Configuration {
    static let results: [Result] = [
        .init(time: 4.0, scramble: "", date: .init())
    ]
    static let resultsWorse: [Result] = [
        .init(time: 4.0, scramble: "", date: .init()),
        .init(time: 6.0, scramble: "", date: .init())
    ]
    static let resultsBetterSingle: [Result] = [
        .init(time: 4.0, scramble: "", date: .init()),
        .init(time: 2.0, scramble: "", date: .init())
    ]
    static var resultsBetterAvg5: [Result] {
        [Int](1...5)
            .map { _ in
                Result(time: 5.0, scramble: "", date: .init())
            }
    }
    static var resultsBetterAvg12: [Result] {
        [Int](1...12)
            .map { _ in
                Result(time: 5.0, scramble: "", date: .init())
            }
    }
    static var resultsBetterMo100: [Result] {
        [Int](1...100)
            .map { _ in
                Result(time: 5.0, scramble: "", date: .init())
            }
    }
}
