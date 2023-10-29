//
//  DataController.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 19/09/2022.
//

import Foundation
import CoreData
import Combine
import SwiftUI

final class DataController: DataControllerProtocol {
    
    // MARK: - Properties
    
    private let container = NSPersistentContainer(name: "SpeedcubeTimer")
    private var loadedSessions: [CDSession] = []
    private var sessions: [CubingSession] {
        loadedSessions.compactMap { CubingSession(from: $0) }
    }
    
    @Published private var buffer: Int = 0
    private let bufferLimit: Int = 10
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    
    init() {
        container
            .loadPersistentStores { description, error in
                if let error = error {
                    debugPrint("Core data failed to load \(error.localizedDescription)")
                }
                
                self.container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
            }
        
        $buffer
            .dropFirst()
            .filter { $0 > self.bufferLimit }
            .sink { _ in
                self.flush()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private
    
    private func loadedOrNewSession(from session: CubingSession) -> CDSession {
        if let existing = loadedSessions.filter({ $0.id == session.id }).first {
            return existing
        } else {
            let new = session.newCdSession(with: container.viewContext)
            loadedSessions.append(new)
            return new
        }
    }
    
    // MARK: - DataControllerProtocol
    
    func loadSessions() -> [CubingSession] {
        guard loadedSessions.isEmpty else { return sessions }
        do {
            try container
                .viewContext
                .fetch(
                    CDSession
                        .fetchRequest()
                )
                .save(
                    to: &loadedSessions
                )
            return sessions
        } catch {
            debugPrint("Core data sessions failed to load")
            return []
        }
    }
    
    func save(_ result: Result, to session: CubingSession) {
        loadedOrNewSession(
            from: session
        )
        .addToResults(
            result
                .newCdResult(
                    with: container.viewContext
                )
            )
        
        inscreaseBuffer()
    }
    
    func remove(result: Result, from session: CubingSession) {
        let session = loadedOrNewSession(
            from: session
        )
        session
            .removeFromResults(
                NSSet(
                    array: session
                                .results?
                                .compactMap{
                                    $0 as? CDResult
                                }
                                .filter {
                                    $0.id == result.id
                                } ?? []
                )
            )
        
        inscreaseBuffer()
    }
    
    func erase(session: CubingSession) {
        let session = loadedOrNewSession(
            from: session
        )
        session
            .results?
            .compactMap {
                $0 as? NSManagedObject
            }
            .forEach {
                container
                    .viewContext
                    .delete($0)
            }
        session
            .results = []
        session
            .name = nil
        
        inscreaseBuffer()
    }
    
    func changeName(of session: CubingSession, to name: String?) {
        loadedOrNewSession(
            from: session
        )
        .name = name
        
        inscreaseBuffer()
    }
    
    func reset() {
        guard !loadedSessions.isEmpty else { return }
        loadedSessions
            .forEach {
                container
                    .viewContext
                    .delete($0)
            }
        loadedSessions = []
            
        inscreaseBuffer()
    }
}

// MARK: - Buffer

private extension DataController {
    func inscreaseBuffer() {
        buffer += 1
    }
    
    func flush() {
        buffer = 0
        do {
            try container
                .viewContext
                .save()
        } catch {
            debugPrint("❗️ error saving context: \(error.localizedDescription)")
        }
    }
}

// MARK: - Bridge

private extension CubingSession {
    init?(from cdSession: CDSession) {
        guard let id = cdSession.id,
              let resultsSet = (cdSession.results as? Set<CDResult>)
        else { return nil }
        self.id = id
        self.name = cdSession.name
        self.index = Int(cdSession.index)
        self.results = resultsSet
                            .compactMap {
                                Result(from: $0)
                            }
                            .sorted {
                                $0.date > $1.date
                            }
        self.cube = cdSession.cube
    }
    
    func newCdSession(with moc: NSManagedObjectContext) -> CDSession {
        let cdSession = CDSession(context: moc)
        cdSession.id = id
        cdSession.name = name
        cdSession.cube = cube
        cdSession.index = Int16(index)
        return cdSession
    }
}

private extension Result {
    init?(from cdResult: CDResult) {
        guard let id = cdResult.id,
              let scramble = cdResult.scramble,
              let date = cdResult.date
        else { return nil }
        self.id = id
        self.scramble = scramble
        self.date = date
        self.time = cdResult.time
    }
    
    @discardableResult
    func newCdResult(with moc: NSManagedObjectContext) -> CDResult {
        let cdResult = CDResult(context: moc)
        cdResult.id = id
        cdResult.scramble = scramble
        cdResult.time = time
        cdResult.date = date
        return cdResult
    }
}

// MARK: - Cache helper

private extension Array {
    func save(to array: inout [Element]) {
        array = self
    }
}
