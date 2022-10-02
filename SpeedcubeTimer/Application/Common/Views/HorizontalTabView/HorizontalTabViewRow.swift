//
//  HorizontalTabViewRow.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 02/10/2022.
//

import SwiftUI

struct HorizontalTabViewRow {
    private let id: UUID = .init()
    @ViewBuilder let destination: () -> AnyView
    @ViewBuilder let label: () -> AnyView
    
    init<Label: View, Destination: View>(destination: @escaping () -> Destination, label: @escaping () -> Label) {
        self.destination = {
            AnyView(
                destination()
            )
        }
        self.label = {
            AnyView(
                label()
            )
        }
    }
}

extension HorizontalTabViewRow: Hashable, Equatable {
    static func == (lhs: HorizontalTabViewRow, rhs: HorizontalTabViewRow) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
