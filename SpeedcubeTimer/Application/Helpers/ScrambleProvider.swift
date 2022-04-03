//
//  ScrambleProvider.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/03/2022.
//

import Foundation

struct ScrambleProvider {
    static func newScramble(for cube: Cube) -> String {
        switch cube {
        case .two:
            return newScramble(availableMoves: ["R", "F", "U"], length: 12)
        case .three:
            return newScramble(availableMoves: ["R", "F", "U", "L", "B", "D"], length: 20)
        }
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
