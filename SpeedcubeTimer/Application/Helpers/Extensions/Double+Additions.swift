//
//  Double+Additions.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 10/04/2022.
//

import Foundation

extension Array where Element == Double {
    var average: Double? {
        guard !self.isEmpty else { return nil }
        
        var average: Double = 0.0
        forEach { element in
            average += element
        }
        return average/Double(count)
    }
}
