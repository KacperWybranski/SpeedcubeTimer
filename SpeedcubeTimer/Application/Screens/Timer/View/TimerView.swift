//
//  TimerView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/03/2022.
//

import SwiftUI

private enum Configuration {
    static let timerTimeInterval: TimeInterval = 0.01
    static let timerPreinspectionTimeInterval: TimeInterval = 1
    static let preinpectionSeconds: TimeInterval = 15.00
}

struct TimerView: View {
    @EnvironmentObject var store: Store<AppState>
    
    var state: TimerViewState { store.state.screenState(for: .timer) ?? .init() }
    
    var timeString: String {
        if state.cubingState == .preinspectionOngoing || state.cubingState == .preinspectionReady {
            return state.time.asTextOnlyFractionalPart
        } else {
            return state.time.asTextWithTwoDecimal
        }
    }
    
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
            
            Text(timeString)
                .foregroundColor(state.cubingState.timerTextColor)
                .font(.system(size: 70))
                .multilineTextAlignment(.center)
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    store.dispatch(TimerViewStateAction.touchBegan)
                }
                .onEnded { _ in
                    store.dispatch(TimerViewStateAction.touchEnded)
                }
        )
        .onChange(of: state.cubingState) { newState in
            switch newState {
            case .preinspectionOngoing:
                startPreinspectionTimer()
            case .ended:
                stopTimer()
                saveResult()
            case .ongoing:
                stopTimer()
                startTimer()
            default:
                break
            }
        }
    }
    
    private func startPreinspectionTimer() {
        let startDate = Date()
        store.dispatch(TimerViewStateAction.updateTime(Configuration.preinpectionSeconds))
        timer = Timer.scheduledTimer(withTimeInterval: Configuration.timerPreinspectionTimeInterval, repeats: true) { timer in
            let newTime = Configuration.preinpectionSeconds - (Date().timeIntervalSince1970 - startDate.timeIntervalSince1970)
            store.dispatch(TimerViewStateAction.updateTime(newTime))
        }
    }
    
    private func startTimer() {
        let startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: Configuration.timerTimeInterval, repeats: true) { timer in
            let newTime = Date().timeIntervalSince1970 - startDate.timeIntervalSince1970
            store.dispatch(TimerViewStateAction.updateTime(newTime))
        }
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    private func saveResult() {
        let result = Result(time: state.time,
                            scramble: state.scramble,
                            date: .init())
        store.dispatch(TimerViewStateAction.saveResult(result))
    }
    
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        let session = CubingSession(results: [], cube: .three, index: 1)
        let timerViewState = TimerViewState(cubingState: .idle,
                                            time: 0.00,
                                            cube: .three,
                                            scramble: ScrambleProvider.newScramble(for: .three),
                                            isPreinspectionOn: true)
        let store = Store
            .init(initial: .forPreview(screenStates: [.timerScreen(timerViewState)],
                                       session: session),
                  reducer: AppState.reducer)
        TimerView()
            .environmentObject(store)
    }
}
