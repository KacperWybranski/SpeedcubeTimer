//
//  ResultTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 22/08/2022.
//

import Foundation
import XCTest
import SpeedcubeTimer

class ResultTests: XCTestCase {
    
    func testBestFromResultArray() {
        
        // Input
        
        let resultBest = Configuration.resultTwoSeconds
        let resultMedium = Configuration.resultFiveSeconds
        let resultWorst = Configuration.resultNineSeconds
        
        let results = [resultWorst, resultMedium, resultBest]
        
        // Test
        
        XCTAssertEqual(results.best, resultBest)
    }
    
    func testWorstFromResultArray() {
        
        // Input
        
        let resultBest = Configuration.resultTwoSeconds
        let resultMedium = Configuration.resultFiveSeconds
        let resultWorst = Configuration.resultNineSeconds
        
        let results = [resultWorst, resultMedium, resultBest]
        
        // Test
        
        XCTAssertEqual(results.worst, resultWorst)
    }
    
    func testAverageFromResultArray() {
        
        // Input
        
        let resultBest = Configuration.resultTwoSeconds
        let resultMedium = Configuration.resultFiveSeconds
        let resultWorst = Configuration.resultNineSeconds
        
        let results = [resultWorst, resultMedium, resultBest]
        
        let expectedAvg = Configuration.average
        
        // Test
        
        XCTAssertEqual(results.average, expectedAvg)
    }
    
    func testEmptyResultArray() {
        
        // Input
        
        let results = [Result]()
        
        // Test
        
        XCTAssertNil(results.average)
        XCTAssertNil(results.best)
        XCTAssertNil(results.worst)
    }
    
}

private enum Configuration {
    static let resultFiveSeconds: Result = .init(time: 5.0, scramble: "D B U L'", date: Date())
    static let resultTwoSeconds: Result = .init(time: 2.0, scramble: "S C R A M B L E", date: Date())
    static let resultNineSeconds: Result = .init(time: 9.0, scramble: "W O R S T", date: Date())
    static let average: Double = 16/3
}
