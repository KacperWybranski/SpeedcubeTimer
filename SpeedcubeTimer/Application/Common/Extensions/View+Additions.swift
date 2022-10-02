//
//  View+Additions.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 01/04/2022.
//

import Foundation
import SwiftUI

extension View {
    /// hide view on condition
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0.0 : 1.0)
    }
}

extension View {
    /// return view with applied modifier when condition met, returns self otherwise
    @ViewBuilder
    func on<V>(condition: Bool, modifier: (AnyView) -> V) -> some View where V: View {
        if condition {
            modifier(AnyView(self))
        } else {
            self
        }
    }
}
