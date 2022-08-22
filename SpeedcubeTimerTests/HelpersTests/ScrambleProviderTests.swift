//
//  ScrambleProviderTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 22/08/2022.
//

import Foundation
import XCTest

class ScrambleProviderTests: XCTestCase {
    
    override func setUpWithError() throws { }
    
    override func tearDownWithError() throws { }
    
    func testNewScrambleForCubeThree() {
        
        // Input
        
        let cube: Cube = .three
        let scramble = ScrambleProvider.newScramble(for: cube)
        let reduced = scramble
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: "2", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        // Test
        
        XCTAssertEqual(reduced.count, cube.scrambleLength)
        reduced
            .forEach {
                XCTAssertTrue(cube.availableMoves.contains("\($0)"))
            }
    }
    
    func testNewScrambleForCubeTwo() {
        
        // Input
        
        let cube: Cube = .three
        let scramble = ScrambleProvider.newScramble(for: cube)
        let reduced = scramble
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: "2", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        // Test
        
        XCTAssertEqual(reduced.count, cube.scrambleLength)
        reduced
            .forEach {
                XCTAssertTrue(cube.availableMoves.contains("\($0)"))
            }
    }
    
}
