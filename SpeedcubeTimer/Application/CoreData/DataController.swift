//
//  DataController.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 19/09/2022.
//

import Foundation
import CoreData

final class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "SpeedcubeTimerModel")
    
    init() {
        container
            .loadPersistentStores { description, error in
                if let error = error {
                    debugPrint("Core data failed to load \(error.localizedDescription)")
                }
            }
    }
    
    func save(_ result: Result) {
        let coreDataResult = CDResult(context: container.viewContext)
        coreDataResult.time = result.time
        coreDataResult.scramble = result.scramble
        try? container.viewContext.save()
    }
}
