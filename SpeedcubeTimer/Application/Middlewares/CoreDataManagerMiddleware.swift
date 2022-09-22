//
//  CoreDataManagerMiddleware.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 19/09/2022.
//

import Combine

extension Middlewares {
    static let dataController = DataController()
    
    static let coreDataManager: Middleware<AppState> = { state, action in
        switch action {
        case TimerViewStateAction.saveResult(let result):
            dataController
                .save(result)
        default:
            break
        }
        
        return Empty()
            .eraseToAnyPublisher()
    }
}
