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
