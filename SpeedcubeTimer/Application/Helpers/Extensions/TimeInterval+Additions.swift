//
//  TimeInterval+Additions.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 29/03/2022.
//

import Foundation

extension TimeInterval {
    var asTextWithFormatting: String {
        String(format: "%.2f", self)
    }
}
