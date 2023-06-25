//
//  Optional+Additions.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 10/04/2022.
//

import Foundation

extension Optional {
    
    var isNil: Bool {
        self == nil
    }
    
    var isNotNil: Bool {
        self != nil
    }
}
