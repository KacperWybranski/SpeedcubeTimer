//
//  TimeInterval+Additions.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 29/03/2022.
//

import Foundation

extension TimeInterval {
    var asTimeWithTwoDecimal: String {
        if self >= 60.0 {
            let minutes = Int(self) / 60
            let seconds = (self - Double(minutes)*60.0)
            return "\(minutes):\(String(format: "%.2f", seconds))"
        }
        return String(format: "%.2f", self)
    }
    
    var asTextOnlyFractionalPart: String {
        String(format: "%.0f", self)
    }
}
