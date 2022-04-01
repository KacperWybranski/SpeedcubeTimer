//
//  View+Additions.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 01/04/2022.
//

import Foundation
import SwiftUI

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0.0 : 1.0)
    }
}
