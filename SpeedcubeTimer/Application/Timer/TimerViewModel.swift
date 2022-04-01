//
//  TimerViewModel.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/03/2022.
//

import SwiftUI
import Combine

class TimerViewModel: ObservableObject {
    private var settings: AppSettings
    private var state: CubingState = .idle
    private var timer: Timer?
    private var anyCancellable: AnyCancellable?
    
    @Published var time: TimeInterval = 0.0
    @Published var scramble: String
    @Published var timerTextColor: Color = .white
    @Published var shouldScrambleBeHidden: Bool = false
    
    init(settings: AppSettings) {
        self.settings = settings
        self.scramble = ScrambleProvider.newScramble(for: settings.currentSession.cube)
        
        anyCancellable = settings.$currentSession.sink { [weak self] newSession in
            guard let self = self else { return }
            self.reset(newCube: newSession.cube)
        }
    }
    
    func touchBegan() {
        switch state {
        case .idle:
            state = .ready
            timerTextColor = .yellow
            time = 0.0
        case .ongoing:
            state = .ended
            timerTextColor = .red
            stopTimer()
            saveResult()
        default:
            break
        }
    }
    
    func touchEnded() {
        switch state {
        case .ready:
            state = .ongoing
            timerTextColor = .green
            shouldScrambleBeHidden = true
            startTimer()
        case .ended:
            state = .idle
            timerTextColor = .white
            scramble = newScramble()
            shouldScrambleBeHidden = false
        default:
            break
        }
    }
    
    private func reset(newCube: Cube) {
        stopTimer()
        state = .idle
        time = 0.0
        scramble = ScrambleProvider.newScramble(for: newCube)
        timerTextColor = .white
        shouldScrambleBeHidden = false
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.time += 0.01
        }
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    private func saveResult() {
        let newResult = Result(time: time, scramble: scramble, date: Date.now)
        settings.currentSession.results.append(newResult)
    }
    
    private func newScramble() -> String {
        ScrambleProvider.newScramble(for: settings.currentSession.cube)
    }
}
