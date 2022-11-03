//
//  HorizontalTabViewBar.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 02/10/2022.
//

import SwiftUI

struct HorizontalTabViewBar: View {
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
                            .foregroundColor(
                                selectedIndex == index ? .primaryTheme : .white
                            )
                    }
                }
            }
            .animation(.none, value: selectedIndex)
        }
        .navigationViewStyle(.stack)
    }
}