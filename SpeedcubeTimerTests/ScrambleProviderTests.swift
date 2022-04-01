//
//  ScrambleProviderTests.swift
//  SpeedcubeTimerTests
//
//  Created by Kacper on 01/04/2022.
//

import XCTest
@testable import SpeedcubeTimer

class ScrambleProviderTests: XCTestCase {

    func testNewScrambleForCubeTwo() {
        let scramble = ScrambleProvider.newScramble(for: .two)
        
        XCTAssertEqual(lengthOfScramble(scramble), TestConfiguration.scrambleForTwoLength)
    }
    
    func testNewScrambleForCubeThree() {
        let scramble = ScrambleProvider.newScramble(for: .three)
        
        XCTAssertEqual(lengthOfScramble(scramble), TestConfiguration.scrambleForThreeLength)
    }
    
    private func lengthOfScramble(_ scramble: String) -> Int {
        scramble
            .filter {
                $0.isLetter
            }
            .count
    }
}

private enum TestConfiguration {
    static let scrambleForTwoLength = 12
    static let scrambleForThreeLength = 20
}
