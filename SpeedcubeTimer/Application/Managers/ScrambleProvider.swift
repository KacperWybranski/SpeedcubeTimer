//
//  ScrambleProvider.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/03/2022.
//

import Foundation

struct ScrambleProvider {
    static func newScramble(for cube: Cube) -> String {
        newScramble(availableMoves: cube.availableMoves,
                    availableModifiers: cube.availableModifiers,
                    length: cube.scrambleLength)
    }
    
    private static func newScramble(availableMoves: [Move], availableModifiers: [MoveModifier], length: Int) -> String {
        var scrambleMoves = [ModifiedMove]()
        for index in 0..<length {
            var randomMove: Move = .none
            let randomModifier = availableModifiers.randomElement() ?? .none
            
            while randomMove == .none || (index != 0 && scrambleMoves[index-1].move == randomMove) {
                randomMove = availableMoves.randomElement() ?? .none
            }
            
            scrambleMoves.append(ModifiedMove(move: randomMove, modifier: randomModifier))
        }
        var scramble: String = .empty
        scrambleMoves
            .forEach { move in
                scramble += (move.asString + " ")
        }
        return scramble
    }
}

extension Cube {
    
    /// available moves
    var availableMoves: [Move] {
        switch self {
        case .two:
            return [.R, .F, .U]
        case .three, .four, .five, .six:
            return [.R, .F, .U, .L, .B, .D]
        }
    }
    
    /// available modifiers (prime, doubled, double layer)
    var availableModifiers: [MoveModifier] {
        switch self {
        case .two:
            return [.doubled, .prime, .none]
        case .three:
            return [.doubled, .prime, .none]
        case .four, .five:
            return [.doubleLayer, .doubled, .prime, .combined(available: [.doubleLayer, .doubled, .prime]), .none]
        case .six:
            return [.doubleLayer, .tripleLayer, .doubled, .prime, .combined(available: [.doubleLayer, .tripleLayer, .doubled, .prime]), .none]
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
        case .five:
            return 60
        case .six:
            return 80
        }
    }
}

// MARK: - Move

enum Move: String {
    case R
    case L
    case U
    case D
    case F
    case B
    
    case none
}

// MARK: - MoveModifier

enum MoveModifier: Equatable {
    case doubleLayer
    case tripleLayer
    case prime
    case doubled
    case combined(available: [MoveModifier])
    
    case none
    
    var priorityForCombining: Int {
        switch self {
        case .doubleLayer, .tripleLayer:
            return 0
        case .doubled, .prime, .combined, .none:
            return 1
        }
    }
    
    func canBeCombined(with another: MoveModifier) -> Bool {
        switch (self, another) {
        case (.doubled, .prime), (.prime, .doubled):
            return false
        case (.doubleLayer, .tripleLayer), (.tripleLayer, .doubleLayer):
            return false
        default:
            return true
        }
    }
    
    func apply(to input: Move) -> String {
        apply(to: input.rawValue)
    }
    
    private func apply(to input: String) -> String {
        switch self {
        case .doubleLayer:
            return input + "w"
        case .tripleLayer:
            return "3" + input + "w"
        case .prime:
            return input + "'"
        case .doubled:
            return input + "2"
        case .combined(let availableModifiers):
            if availableModifiers.isEmpty { return input }
            if availableModifiers.count == 1 { return availableModifiers.first?.apply(to: input) ?? input }
            
            var random1: MoveModifier = .none
            var random2: MoveModifier = .none
            while random1 == .none || random2 == .none || random1 == random2 || !random1.canBeCombined(with: random2) {
                random1 = availableModifiers.randomElement() ?? .none
                random2 = availableModifiers.randomElement() ?? .none
            }
            
            var modified: String = input
            [random1, random2]
                .sorted {
                    $0.priorityForCombining < $1.priorityForCombining
                }
                .forEach {
                    modified = $0.apply(to: modified)
                }
            return modified
        case .none:
            return input
        }
    }
}

// MARK: - Modified move

struct ModifiedMove {
    let move: Move
    let modifier: MoveModifier
    
    var asString: String {
        modifier.apply(to: move)
    }
}
