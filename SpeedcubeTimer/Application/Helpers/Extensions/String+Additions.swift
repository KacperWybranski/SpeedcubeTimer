//
//  String+Additions.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 03/04/2022.
//

import Foundation

extension String {
    static let empty: String = ""
    
    func wrappedInParentheses(_ wrap: Bool) -> String {
        if wrap {
            return "(\(self))"
        } else {
            return self
        }
    }
}
