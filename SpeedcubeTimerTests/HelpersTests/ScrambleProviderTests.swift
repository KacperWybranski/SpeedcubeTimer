//
//  ScrambleProviderTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 22/08/2022.
//

import Foundation
import XCTest
import SpeedcubeTimer

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
        let expectedValue = "Fw"
        
        // Reduce
        
        let modified = ModifiedMove(move: move, modifier: modifier)
        
        // Test
        
        XCTAssertEqual(expectedValue, modified.asString)

    }
    
    func testModifiedMoveTripleLayer() {
        
        // Input
        
        let move: Move = .F
        let modifier: MoveModifier = .tripleLayer
        let expectedValue = "3Fw"
        
        // Reduce
        
        let modified = ModifiedMove(move: move, modifier: modifier)
        
        // Test
        
        XCTAssertEqual(expectedValue, modified.asString)
    }
    
    func testModifiedMoveCombined() {
        
        // Input
        
        let move: Move = .F
        let modifier: MoveModifier = .combined(available: [.doubleLayer, .doubled])
        let expectedValue = "Fw2"
        
        // Reduce
        
        let modified = ModifiedMove(move: move, modifier: modifier)
        
        // Test
        
        XCTAssertEqual(expectedValue, modified.asString)

    }
    
    func testModifiedMoveCombinedWithNoAvailable() {
        
        // Input
        
        let move: Move = .F
        let modifier: MoveModifier = .combined(available: [])
        let expectedValue = "F"
        
        // Reduce
        
        let modified = ModifiedMove(move: move, modifier: modifier)
        
        // Test
        
        XCTAssertEqual(expectedValue, modified.asString)
    }
    
    func testModifiedMoveCombinedWithOnlyOne() {
        
        // Input
        
        let move: Move = .F
        let modifier: MoveModifier = .combined(available: [.doubled])
        let expectedValue = "F2"
        
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
            .replacingOccurrencesWithEmpty(of: ["'","2"," "])
        
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
            .replacingOccurrencesWithEmpty(of: ["'","2"," "])
        
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
    
    func testNewScrambleForCubeFour() {
        
        // Input
        
        let cube: Cube = .four
        let scramble = ScrambleProvider.newScramble(for: cube)
        
        // Reduce
        
        let reduced = scramble
            .replacingOccurrencesWithEmpty(of: ["'","2"," ","w"])
        
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
    
    func testNewScrambleForCubeFive() {
        
        // Input
        
        let cube: Cube = .five
        let scramble = ScrambleProvider.newScramble(for: cube)
        
        // Reduce
        
        let reduced = scramble
            .replacingOccurrencesWithEmpty(of: ["'","2"," ","w"])
        
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
    
    func testNewScrambleForCubeSix() {
        
        // Input
        
        let cube: Cube = .six
        let scramble = ScrambleProvider.newScramble(for: cube)
        
        // Reduce
        
        let reduced = scramble
            .replacingOccurrencesWithEmpty(of: ["'","2"," ","w","3"])
        
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
    
    func testNewScrambleForCubeSeven() {
        
        // Input
        
        let cube: Cube = .seven
        let scramble = ScrambleProvider.newScramble(for: cube)
        
        // Reduce
        
        let reduced = scramble
            .replacingOccurrencesWithEmpty(of: ["'","2"," ","w","3"])
        
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

private extension String {
    func replacingOccurrencesWithEmpty(of targets: [any StringProtocol]) -> String {
        var cleanedSelf = self
        targets
            .forEach {
                cleanedSelf = cleanedSelf
                    .replacingOccurrences(of: $0, with: "")
            }
        return cleanedSelf
    }
}
