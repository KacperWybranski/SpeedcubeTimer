//
//  TimerView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/03/2022.
//

import SwiftUI
import ComposableArchitecture

private enum Configuration {
    static let timerTimeInterval: TimeInterval = 0.01
    static let timerPreinspectionTimeInterval: TimeInterval = 1
    static let preinpectionSeconds: TimeInterval = 15.00
}

struct TimerView: View {
    let store: Store<TimerFeature.State, TimerFeature.Action>
    
    @State private var timer: Timer?
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color
                    .black
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Color.clear
                        .overlay(
                            Text(viewStore.scramble)
                                .hidden(viewStore.cubingState.shouldScrambleBeHidden)
                                .foregroundColor(.lightGray)
                                .font(.system(size: 40))
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .padding(15)
                        )
                    
                    Text(viewStore.formattedTime)
                        .foregroundColor(viewStore.cubingState.timerTextColor)
                        .font(.system(size: 70))
                        .multilineTextAlignment(.center)
                    
                    
                    Color.clear
                }
            }
            .alert(
                self.store.scope(state: \.alert),
                dismiss: .dismissPopup
            )
            .recordOverlay(
                text: viewStore.overlayText ?? .empty,
                .init(get: { viewStore.overlayText.isNotNil },
                      set: { if !$0 { viewStore.send(.hideOverlay) } })
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        viewStore
                            .send(
                                .touchBegan
                            )
                    }
                    .onEnded { _ in
                        viewStore
                            .send(
                                .touchEnded
                            )
                    }
            )
            .onAppear {
                viewStore
                    .send(
                        .loadSession
                    )
            }
            .onChange(of: viewStore.cubingState) { newState in
                switch newState {
                case .preinspectionOngoing:
                    UIApplication.shared.isIdleTimerDisabled = true
                case .ended:
                    UIApplication.shared.isIdleTimerDisabled = false
                case .ongoing:
                    UIApplication.shared.isIdleTimerDisabled = true
                default:
                    break
                }
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(
            store: Store(
                initialState: TimerFeature
                                        .State(
                                            cubingState: .idle,
                                            time: 0.0,
                                            cube: .four,
                                            scramble: ScrambleProvider.newScramble(for: .four)
                                        ),
                reducer: TimerFeature(
                    mainQueue: .main,
                    overlayCheckPriority: .medium,
                    sessionsManager: SessionsManager(),
                    userSettings: UserSettings()
                )
            )
        )
        .previewDevice("iPhone 13 mini")
    }
}
