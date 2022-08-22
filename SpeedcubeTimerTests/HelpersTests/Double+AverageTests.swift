//
//  Double+AverageTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 22/08/2022.
//

import Foundation
import XCTest

class DoubleAverageTests: XCTestCase {
    
    func testAverageForEmptyArray() {
        
        // Input
        
        let values = [Double]()
        
        // Test
        
        XCTAssertNil(values.average)
    }
    
    func testAverage() {
        
        // Input
        
        let values = Configuration.sampleValues
        let expectedAvg = Configuration.averageForSampleValues
        
        // Test
        
        XCTAssertEqual(expectedAvg, values.average)
        
    }
    
}

private enum Configuration {
    static let sampleValues: [Double] = [4.0, 7.0, 3.0, 91.0]
    static let averageForSampleValues: Double = 26.25
}
