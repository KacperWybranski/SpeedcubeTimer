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
    private var preinspectionTimer: Timer?
    private var anyCancellable: AnyCancellable?
    
    @Published var time: TimeInterval = 0.0
    @Published var scramble: String
    @Published var timerTextColor: Color = .white
    @Published var shouldScrambleBeHidden: Bool = false
    
    var formattedTime: String {
        (state == .preinspectionReady || state == .preinspectionOngoing) ? time.asTextOnlyFractionalPart : time.asTextWithTwoDecimal
    }
    
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
            applyState(.ready)
        case .preinspectionOngoing:
            applyState(.preinspectionReady)
        case .ongoing:
            applyState(.ended)
        default:
            break
        }
    }
    
    func touchEnded() {
        switch state {
        case .ready:
            applyState(settings.isPreinspectionOn ? .preinspectionOngoing : .ongoing)
        case .preinspectionReady:
            applyState(.ongoing)
        case .ended:
            applyState(.idle)
        default:
            break
        }
    }
    
    private func applyState(_ newState: CubingState) {
        switch newState {
        case .idle:
            state = .idle
            timerTextColor = .white
            scramble = newScramble()
            shouldScrambleBeHidden = false
        case .ready:
            state = .ready
            timerTextColor = .yellow
            time = 0.0
        case .ongoing:
            state = .ongoing
            timerTextColor = .green
            shouldScrambleBeHidden = true
            stopPreinspectionTimer()
            time = 0.0
            startTimer()
        case .ended:
            state = .ended
            timerTextColor = .red
            stopTimer()
            saveResult()
        case .preinspectionOngoing:
            state = .preinspectionOngoing
            timerTextColor = .green
            time = 15.0
            shouldScrambleBeHidden = true
            startPreinspectionTimer()
        case .preinspectionReady:
            state = .preinspectionReady
            timerTextColor = .yellow
        }
    }
    
    private func reset(newCube: Cube) {
        stopTimer()
        time = 0.0
        scramble = ScrambleProvider.newScramble(for: newCube)
        timerTextColor = .white
        shouldScrambleBeHidden = false
    }
    
    private func saveResult() {
        let newResult = Result(time: time, scramble: scramble, date: Date.now)
        settings.currentSession.results.append(newResult)
    }
    
    private func newScramble() -> String {
        ScrambleProvider.newScramble(for: settings.currentSession.cube)
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
    
    private func startPreinspectionTimer() {
        preinspectionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.time -= 1
        }
    }
    
    private func stopPreinspectionTimer() {
        guard preinspectionTimer != nil else { return }
        preinspectionTimer?.invalidate()
        preinspectionTimer = nil
    }
}
