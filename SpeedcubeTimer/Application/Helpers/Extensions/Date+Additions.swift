//
//  Date+Additions.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 18/08/2022.
//

import Foundation

extension Date {
    var formatted: String {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter
        }()
        
        return dateFormatter.string(from: self)
    }
}
