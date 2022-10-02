//
//  HorizontalTabView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 30/09/2022.
//

import SwiftUI

struct HorizontalTabView: View {
    @Binding var selectedRow: Int
    let rows: [HorizontalTabViewRow]
    
    var body: some View {
        HStack {
            HorizontalTabViewBar(
                rows: rows,
                selectedIndex: $selectedRow
            )
                .frame(width: 200)

            Color
                .clear
                .overlay(
                    rows[selectedRow]
                        .destination()
                        .navigationViewStyle(.stack)
                )
        }
    }
}

private struct HorizontalTabViewBar: View {
    let rows: [HorizontalTabViewRow]
    @Binding var selectedIndex: Int
    
    var body: some View {
        NavigationView {
            List {
                ForEach(
                    Array(
                        zip(rows.indices, rows)
                    ),
                    id: \.0
                ) { (index, row) in
                    Button {
                        selectedIndex = Int(index)
                    } label: {
                        row
                            .label()
                            .foregroundColor(.white)
                    }
                    .on(condition: selectedIndex == index) {
                        $0.listRowBackground(Color.primaryTheme)
                    }
                }
            }
            .animation(.none, value: selectedIndex)
        }
        .navigationViewStyle(.stack)
    }
}

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

// Optional modifier

extension View {
    @ViewBuilder
    func on<V>(condition: Bool, modifier: (AnyView) -> V) -> some View where V: View {
        if condition {
            modifier(AnyView(self))
        } else {
            self
        }
    }
}
