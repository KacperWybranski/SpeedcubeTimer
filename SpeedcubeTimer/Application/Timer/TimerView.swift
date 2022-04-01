//
//  TimerView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/03/2022.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel
    
    init(viewModel: TimerViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color
                .black
                .ignoresSafeArea()
            
            Text(viewModel.scramble)
                .hidden(viewModel.shouldScrambleBeHidden)
                .foregroundColor(.white)
                .font(.system(size: 40))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 15)
                .offset(y: -150)
            
            Text(viewModel.time.asTextWithFormatting)
                .foregroundColor(viewModel.timerTextColor)
                .font(.system(size: 70))
                .multilineTextAlignment(.center)
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    viewModel.touchBegan()
                }
                .onEnded { _ in
                    viewModel.touchEnded()
                }
        )
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(viewModel: TimerViewModel(settings: AppSettings(sessions: [.initialSession])))
    }
}
