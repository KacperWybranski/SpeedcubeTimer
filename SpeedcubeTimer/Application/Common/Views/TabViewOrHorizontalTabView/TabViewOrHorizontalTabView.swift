//
//  TabViewOrHorizontalTabView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 02/10/2022.
//

import SwiftUI

private let useDynamiciPadLayout: Bool = false

/// Dynamic view changing according to current horizontal size class. Classic TabView if sizeClass == .compact, sidebar-like view with always visible bar (like in Settings App) otherwise.
struct TabViewOrHorizontalTabView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @Binding var selection: Int
    let rows: [TabViewOrHorizontalTabViewRow]
    
    var body: some View {
        if sizeClass == .compact || !useDynamiciPadLayout {
            TabView(selection: $selection) {
                ForEach(
                    Array(
                        zip(rows.indices, rows)
                    ),
                    id: \.0
                ) { (index, row) in
                    row
                        .destination()
                        .navigationViewStyle(.stack)
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
