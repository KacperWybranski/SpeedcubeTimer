//
//  ScrambleProvider.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/03/2022.
//

import Foundation

struct ScrambleProvider {
    static func newScramble(for cube: Cube) -> String {
        newScramble(availableMoves: cube.availableMoves, length: cube.scrambleLength)
    }
    
    private static func newScramble(availableMoves: [String], length: Int) -> String {
        let availableModifiers: [String] = ["", "'", "2"]
        var scrambleMoves = [String]()
        for index in 0..<length {
            if var random = availableMoves.randomElement() {
                if index != 0 {
                    while (scrambleMoves[index-1].contains(random)) {
                        if let newRandom = availableMoves.randomElement() { random = newRandom }
                    }
                }
                if let randomModifier = availableModifiers.randomElement() { random += randomModifier }
                scrambleMoves.append(random)
            }
        }
        var scramble: String = .empty
        scrambleMoves.forEach { move in
            scramble += "\(move) "
        }
        return scramble
    }
}

extension Cube {
    
    /// available moves excluding double and prime moves
    var availableMoves: [String] {
        switch self {
        case .two:
            return ["R", "F", "U"]
        case .three:
            return ["R", "F", "U", "L", "B", "D"]
        case .four:
            return ["R", "F", "U", "L", "B", "D", "r", "f", "u", "l", "b", "d"]
        }
    }
    
    var scrambleLength: Int {
        switch self {
        case .two:
            return 12
        case .three:
            return 20
        case .four:
            return 40
        }
    }
}
