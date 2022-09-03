//
//  OverlayAnimationView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 24/08/2022.
//

import SwiftUI

struct OverlayAnimationView: View {
    var text: String
    var animationEnded: (() -> Void)
    var themeColor: Color = .randomThemeForOverlay
    
    @State var isOverlayColorVisible: Bool = false
    @State var isTextVisible: Bool = false
    
    var body: some View {
        ZStack {
            if isOverlayColorVisible {
                themeColor
                    .transition(.asymmetric(insertion: .quarterCircle, removal: .opacity))
            }
            
            if isTextVisible {
                Text(text)
                    .foregroundColor(themeColor)
                    .font(.system(size: 30))
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
                    .offset(x: 0, y: 200)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: Configuration.showOverlayDuration)) {
                isOverlayColorVisible = true
            }
            withAnimation(.linear(duration: Configuration.hideOverlayShowTextDuration).delay(1.0)) {
                isOverlayColorVisible = false
                isTextVisible = true
            }
            withAnimation(.easeIn(duration: Configuration.hideTextDuration).delay(3.0)) {
                isTextVisible = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                animationEnded()
            }
        }
    }
    
    private enum Configuration {
        static let showOverlayDuration: TimeInterval = 1.0
        static let hideOverlayShowTextDuration: TimeInterval = 0.8
        static let hideTextDuration: TimeInterval = 0.5
    }
}

// MARK: - Preview View

struct SampleView: View {
    @State var showOverlay: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Button("Tap to see animation") {
                    showOverlay = true
                }
                .buttonStyle(.automatic)
            }
            
            if showOverlay {
                OverlayAnimationView(text: "Hello :)") {
                    showOverlay = false
                }
            }
        }
    }
}

private extension Color {
    static var randomThemeForOverlay: Color {
        [.lightBlue, .lightYellow, .lightPink]
            .randomElement() ?? .lightYellow
    }
}

struct OverlayAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        SampleView()
    }
}
