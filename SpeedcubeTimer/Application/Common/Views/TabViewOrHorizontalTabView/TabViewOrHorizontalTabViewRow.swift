//
//  TabViewOrHorizontalTabViewRow.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 02/10/2022.
//

import SwiftUI

struct TabViewOrHorizontalTabViewRow {
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

extension TabViewOrHorizontalTabViewRow: Hashable, Equatable {
    static func == (lhs: TabViewOrHorizontalTabViewRow, rhs: TabViewOrHorizontalTabViewRow) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

