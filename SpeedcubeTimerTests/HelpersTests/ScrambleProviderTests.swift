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
    
    func testModifiedMoveDoubled() {
        
        // Input
        
        let move: Move = .F
        let modifier: MoveModifier = .doubled
        let expectedValue = "F2"
        
        // Reduce
        
        let modified = ModifiedMove(move: move, modifier: modifier)
        
        // Test
        
        XCTAssertEqual(expectedValue, modified.asString)

    }
    
    func testModifiedMovePrime() {
        
        // Input
        
        let move: Move = .F
        let modifier: MoveModifier = .prime
        let expectedValue = "F'"
        
        // Reduce
        
        let modified = ModifiedMove(move: move, modifier: modifier)
        
        // Test
        
        XCTAssertEqual(expectedValue, modified.asString)

    }
    
    func testModifiedMoveDoubleLayer() {
        
        // Input
        
        let move: Move = .F
        let modifier: MoveModifier = .doubleLayer
        let expectedValue = "f"
        
        // Reduce
        
        let modified = ModifiedMove(move: move, modifier: modifier)
        
        // Test
        
        XCTAssertEqual(expectedValue, modified.asString)

    }
    
    func testModifiedMoveCombined() {
        
        // Input
        
        let move: Move = .F
        let modifier: MoveModifier = .combined(available: [.doubleLayer, .doubled])
        let expectedValue = "f2"
        
        // Reduce
        
        let modified = ModifiedMove(move: move, modifier: modifier)
        
        // Test
        
        XCTAssertEqual(expectedValue, modified.asString)

    }
    
    func testNewScrambleForCubeThree() {
        
        // Input
        
        let cube: Cube = .three
        let scramble = ScrambleProvider.newScramble(for: cube)
        
        // Reduce
        
        let reduced = scramble
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: "2", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        // Test
        
        XCTAssertEqual(reduced.count, cube.scrambleLength)
        reduced
            .forEach { stringMove in
                XCTAssertTrue(
                    cube
                        .availableMoves
                        .map {
                            $0.rawValue
                        }
                        .contains("\(stringMove)")
                )
            }
    }
    
    func testNewScrambleForCubeTwo() {
        
        // Input
        
        let cube: Cube = .two
        let scramble = ScrambleProvider.newScramble(for: cube)
        
        // Reduce
        
        let reduced = scramble
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: "2", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        // Test
        
        XCTAssertEqual(reduced.count, cube.scrambleLength)
        reduced
            .forEach { stringMove in
                XCTAssertTrue(
                    cube
                        .availableMoves
                        .map {
                            $0.rawValue
                        }
                        .contains("\(stringMove)")
                )
            }
    }
    
}
