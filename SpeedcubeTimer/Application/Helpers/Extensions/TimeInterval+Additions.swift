//
//  TimeInterval+Additions.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 29/03/2022.
//

import Foundation

extension TimeInterval {
    var asTextWithTwoDecimal: String {
        String(format: "%.2f", self)
    }
    
    var asTextOnlyFractionalPart: String {
        String(format: "%.0f", self)
    }
}
