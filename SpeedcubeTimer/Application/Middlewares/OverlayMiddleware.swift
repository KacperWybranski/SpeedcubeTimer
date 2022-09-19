//
//  OverlayMiddleware.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 19/09/2022.
//

import Foundation
import Combine

extension Middlewares {
    static let overlayCheck: Middleware<AppState> = { state, action in
        var overlayText: String?
        
        switch action {
        case AppStateAction.newSessionSet(let newSession):
            let oldSession = state.currentSession
            guard newSession.id == oldSession.id else { break }
            
            if isNewBest(newSession.bestResult,
                         oldSession.bestResult,
                         compareBy: \.time) {
                overlayText = "🤩 new best single 🥳"
            } else if isNewBest(newSession.bestAvgOf(5, mode: .avgOf),
                                oldSession.bestAvgOf(5, mode: .avgOf),
                                compareBy: \.value) {
                overlayText = "🤯 new best avg5 😱"
            } else if isNewBest(newSession.bestAvgOf(12, mode: .avgOf),
                                oldSession.bestAvgOf(12, mode: .avgOf),
                                compareBy: \.value) {
                overlayText = "🎉 new best avg12 🎉"
            } else if isNewBest(newSession.bestAvgOf(100, mode: .meanOf),
                                oldSession.bestAvgOf(100, mode: .meanOf),
                                compareBy: \.value) {
                overlayText = "🪑 new best mo100 👏"
            }
        default:
            break
        }
        
        if let overlayText = overlayText {
            return Just(MainViewStateAction.showOverlay(text: overlayText))
                .eraseToAnyPublisher()
        } else {
            return Empty()
                .eraseToAnyPublisher()
        }
    }
}

private func isNewBest<T, C: Comparable>(_ new: T?, _ old: T?, compareBy keypath: KeyPath<T, C>) -> Bool {
    guard let new = new else { return false }
    guard let old = old else { return true }
    return new[keyPath: keypath] < old[keyPath: keypath]
}
