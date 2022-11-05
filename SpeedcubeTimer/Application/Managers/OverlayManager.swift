//
//  OverlayMiddleware.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 19/09/2022.
//

import Foundation
import Combine

final class OverlayManager {
    enum RecordType {
        case single
        case avg5
        case avg12
        case mo100
        case none
    }
    
    func checkForNewRecord(oldSession: CubingSession, newSession: CubingSession) -> RecordType {
        if isNewBest(
            newSession.bestResult,
            oldSession.bestResult,
            compareBy: \.time
        ) {
            return .single
        } else if isNewBest(
            newSession.bestAvgOf(5, mode: .avgOf),
            oldSession.bestAvgOf(5, mode: .avgOf),
            compareBy: \.value
        ) {
            return .avg5
        } else if isNewBest(
            newSession.bestAvgOf(12, mode: .avgOf),
            oldSession.bestAvgOf(12, mode: .avgOf),
            compareBy: \.value
        ) {
            return .avg12
        } else if isNewBest(
            newSession.bestAvgOf(100, mode: .meanOf),
            oldSession.bestAvgOf(100, mode: .meanOf),
            compareBy: \.value
        ) {
            return .mo100
        } else {
            return .none
        }
    }
}

private func isNewBest<T, C: Comparable>(_ new: T?, _ old: T?, compareBy keypath: KeyPath<T, C>) -> Bool {
    guard let new = new else { return false }
    guard let old = old else { return true }
    return new[keyPath: keypath] < old[keyPath: keypath]
}
