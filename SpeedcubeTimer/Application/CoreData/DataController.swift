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

final class DataController: ObservableObject {
    private let container = NSPersistentContainer(name: "SpeedcubeTimer")
    private var loadedSessions: [CDSession] = []
    
    // MARK: - Initialize
    
    init() {
        container
            .loadPersistentStores { description, error in
                if let error = error {
                    debugPrint("Core data failed to load \(error.localizedDescription)")
                }
                
                self.container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
            }
    }
    
    private func loadedOrNewSession(from session: CubingSession) -> CDSession {
        loadedSessions
            .filter {
                $0.id == session.id
            }
            .first ??
        session
            .newCdSession(
                with: container
                        .viewContext
            )
    }
    
    // MARK: - Getters
    
    func loadSessions() -> [CubingSession] {
        do {
            return try container
                        .viewContext
                        .fetch(
                            CDSession
                                .fetchRequest()
                        )
                        .save(
                            to: &loadedSessions
                        )
                        .compactMap {
                            CubingSession(from: $0)
                        }
        } catch {
            debugPrint("Core data sessions failed to load")
            return []
        }
    }
    
    // MARK: - Setters
    
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
        
        try? container
                .viewContext
                .save()
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
        
        try? container
                .viewContext
                .save()
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
            .name = nil
        
        try? container
            .viewContext
            .save()
    }
    
    func reset() {
        guard !loadSessions().isEmpty else { return }
        loadedSessions
            .forEach {
                container
                    .viewContext
                    .delete($0)
            }
            
        try? container
            .viewContext
            .save()
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
    func save(to array: inout [Element]) -> Self {
        array = self
        return self
    }
}
