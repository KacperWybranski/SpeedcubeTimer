//
//  TimerView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/03/2022.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var store: Store<ReduxAppState>
    
    var state: TimerViewState { store.state.screenState(for: .timer) ?? .init() }
    
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            Color
                .black
                .ignoresSafeArea()
            
            Text(state.scramble)
                .hidden(state.cubingState.shouldScrambleBeHidden)
                .foregroundColor(.white)
                .font(.system(size: 40))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 15)
                .offset(y: -150)
            
            Text(state.time.asTextWithTwoDecimal)
                .foregroundColor(state.cubingState.timerTextColor)
                .font(.system(size: 70))
                .multilineTextAlignment(.center)
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    debugPrint("touch began")
                    store.dispatch(TimerViewStateAction.touchBegan)
                }
                .onEnded { _ in
                    debugPrint("touch ended")
                    store.dispatch(TimerViewStateAction.touchEnded)
                }
        )
        .onChange(of: state.cubingState) { newState in
            switch newState {
            case .ended:
                stopTimer()
            case .ongoing:
                startTimer()
            default:
                break
            }
        }
    }
    
    private func startTimer() {
        let startDate = Date.now
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            let newTime = Date.now.timeIntervalSince1970 - startDate.timeIntervalSince1970
            store.dispatch(TimerViewStateAction.updateTime(newTime))
        }
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        let timerViewState = TimerViewState(cubingState: .idle,
                                            time: 0.90,
                                            cube: .three,
                                            scramble: ScrambleProvider.newScramble(for: .three))
        let store = Store
            .init(initial: ReduxAppState(screens: [.timerScreen(timerViewState)]),
                  reducer: ReduxAppState.reducer)
        TimerView()
            .environmentObject(store)
    }
}
