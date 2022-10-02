//
//  TabViewOrHorizontalTabView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 02/10/2022.
//

import SwiftUI

struct TabViewOrHorizontalTabView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @Binding var selection: Int
    let rows: [TabViewOrHorizontalTabViewRow]
    
    var body: some View {
        if sizeClass == .compact {
            TabView(selection: $selection) {
                ForEach(
                    Array(
                        zip(rows.indices, rows)
                    ),
                    id: \.0
                ) { (index, row) in
                    row
                        .destination()
                        .tabItem(
                            row.label
                        )
                        .tag(index)
                }
            }
        } else {
            HorizontalTabView(
                selectedRow: $selection,
                rows:
                    rows
                        .map { row in
                            HorizontalTabViewRow(
                                destination: row.destination,
                                label: row.label)
                        }
                
            )
        }
    }
}

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
