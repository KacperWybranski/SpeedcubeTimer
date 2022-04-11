//
//  TimerViewModel.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/03/2022.
//

import SwiftUI
import Combine

extension TimerViewModel {
    
    enum CubingState {
        case idle
        case ready
        case ongoing
        case ended
        
        case preinspectionOngoing
        case preinspectionReady
    }
}

class TimerViewModel: ObservableObject {
    private var appState: AppState
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
    
    init(appState: AppState) {
        self.appState = appState
        self.scramble = ScrambleProvider.newScramble(for: appState.currentSession.cube)
        
        anyCancellable = appState.$currentSession.sink { [weak self] newSession in
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
            applyState(appState.isPreinspectionOn ? .preinspectionOngoing : .ongoing)
        case .preinspectionReady:
            applyState(.ongoing)
        case .ended:
            applyState(.idle)
        default:
            break
        }
    }
    
    private func applyState(_ newState: CubingState) {
        state = newState
        
        switch newState {
        case .idle:
            timerTextColor = .white
            scramble = newScramble()
            shouldScrambleBeHidden = false
        case .ready:
            timerTextColor = .yellow
            time = 0.0
        case .ongoing:
            timerTextColor = .green
            shouldScrambleBeHidden = true
            stopPreinspectionTimer()
            time = 0.0
            startTimer()
        case .ended:
            timerTextColor = .red
            stopTimer()
            saveResult()
        case .preinspectionOngoing:
            timerTextColor = .green
            time = 15.0
            shouldScrambleBeHidden = true
            startPreinspectionTimer()
        case .preinspectionReady:
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
        let result = Result(time: time, scramble: scramble, date: Date.now)
        appState.addNewResult(result)
    }
    
    private func newScramble() -> String {
        ScrambleProvider.newScramble(for: appState.currentSession.cube)
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
