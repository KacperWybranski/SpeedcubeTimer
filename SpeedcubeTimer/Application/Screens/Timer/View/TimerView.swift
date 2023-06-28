//
//  TimerView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 22/03/2022.
//

import SwiftUI
import ComposableArchitecture

struct TimerView: View {
    let store: Store<TimerFeature.State, TimerFeature.Action>
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color
                    .black
                    .ignoresSafeArea()
                
                content(viewStore: viewStore)
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
                        viewStore.send(.touchBegan)
                    }
                    .onEnded { _ in
                        viewStore.send(.touchEnded)
                    }
            )
            .onAppear {
                viewStore.send(.loadSession)
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
    
    @ViewBuilder
    func content(viewStore: ViewStore<TimerFeature.State, TimerFeature.Action>) -> some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                if sizeClass != .compact {
                    HStack {
                        Text(viewStore.cube.name)
                        
                        Rectangle()
                            .frame(width: 1, height: 40)
                            .padding(.horizontal, 15)
                            
                        Text(viewStore.sessionName)
                    }
                    .frame(maxWidth: proxy.size.width*0.25)
                    .lineLimit(1)
                    .hidden(viewStore.cubingState.shouldHideLabels)
                    .font(.system(size: 30))
                    .foregroundColor(.lightGray)
                    .padding(.top, 15)
                }
                
                Color.clear
                    .overlay(
                        Text(viewStore.scramble)
                            .hidden(viewStore.cubingState.shouldHideLabels)
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
                                            sessionName: "1",
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
