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
            Text(result.time.asTextWithFormatting)
                .font(.system(size: 60))
                .foregroundColor(.green)
            Spacer()
                .frame(maxHeight: 30)
            Text(result.scramble)
                .multilineTextAlignment(.center)
                .font(.system(size: 25))
            Spacer()
                .frame(maxHeight: 30)
            Text(result.date.formatted())
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
        .init(time: 9.23, scramble: ScrambleProvider.newScramble(for: .three), date: .now)
    }
}
