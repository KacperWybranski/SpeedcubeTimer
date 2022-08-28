//
//  ResultsListEmptyView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/08/2022.
//

import SwiftUI

struct ResultsListEmptyView: View {
    var body: some View {
        VStack {
            Text("Nothing to display 🥺")
                .foregroundColor(.lightGray)
                .font(.system(size: 25, weight: .medium))
            Spacer()
                .frame(height: 20)
            Text("Finish solve to enjoy summary of your results here!")
                .foregroundColor(.lightGray)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Preview

struct ResultsListEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsListEmptyView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 6S")
    }
}
