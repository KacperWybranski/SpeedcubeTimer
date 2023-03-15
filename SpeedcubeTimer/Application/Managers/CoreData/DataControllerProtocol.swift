//
//  DataControllerProtocol.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 30/09/2022.
//

import Foundation

protocol DataControllerProtocol {
    func loadSessions() -> [CubingSession]
    func save(_ result: Result, to session: CubingSession)
    func remove(result: Result, from session: CubingSession)
    func erase(session: CubingSession)
    func reset()
    func changeName(of session: CubingSession, to name: String?)
}
