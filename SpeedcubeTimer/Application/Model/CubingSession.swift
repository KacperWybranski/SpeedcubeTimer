//
//  CubingSession.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 11/04/2022.
//

import Foundation
import SwiftUI

//class CubingSession: ObservableObject, Equatable {
//    @Published var results: [Result]
//    @Published var cube: Cube
//    @Published var sessionindex: Int
//
//    var bestResult: Result? {
//        results.best
//    }
//
//    init(results: [Result], cube: Cube, session: Int) {
//        self.results = results
//        self.cube = cube
//        self.sessionindex = session
//
//    }
//
//    static var initialSession: CubingSession {
//        return CubingSession(results: [], cube: .three, session: 1)
//    }
//
//    static func == (lhs: CubingSession, rhs: CubingSession) -> Bool {
//        return (lhs.results == rhs.results &&
//                lhs.cube == rhs.cube &&
//                lhs.sessionindex == rhs.sessionindex)
//    }
//}

struct CubingSession: Equatable {
    var results: [Result]
    var cube: Cube
    var index: Int
    var id: UUID = UUID()
    
    var bestResult: Result? {
        results.best
    }
    
    static var initialSession: CubingSession {
        return CubingSession(results: [], cube: .three, index: 1)
    }
}
