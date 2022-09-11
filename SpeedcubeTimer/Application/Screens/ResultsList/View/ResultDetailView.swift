//
//  ResultDetailView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 29/03/2022.
//

import SwiftUI

struct ResultDetailView: View {
    var result: Result
    
    var body: some View {
        VStack {
            Text(result.time.asTextWithTwoDecimal)
                .font(.system(size: 60))
                .foregroundColor(.primaryTheme)
            Spacer()
                .frame(height: 40)
            Text(result.scramble)
                .multilineTextAlignment(.center)
                .font(.system(size: 25))
            Spacer()
                .frame(height: 40)
            Text(result.date.formatted)
                .font(.system(size: 20))
        }
        .padding(.horizontal, 20)
    }
}

struct ResultDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ResultDetailView(result: .previewResult)
            .preferredColorScheme(.dark)
    }
}

private extension Result {
    static var previewResult: Result {
        .init(time: 9.23, scramble: ScrambleProvider.newScramble(for: .three), date: .init())
    }
}
