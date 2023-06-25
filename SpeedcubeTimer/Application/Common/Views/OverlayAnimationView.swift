//
//  OverlayAnimationView.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 24/08/2022.
//

import ComposableArchitecture
import SwiftUI

fileprivate struct OverlayAnimationViewModifier: ViewModifier {
    
    // MARK: - Private
    
    @State private var isOverlayColorVisible: Bool = false
    @State private var textOpacity: CGFloat = 0.0
    @Binding private var isPresented: Bool
    
    private var themeColor: Color = .randomThemeForOverlay
    private var text: String
    
    init(text: String, isPresented: Binding<Bool>) {
        self.text = text
        self._isPresented = isPresented
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                    .layoutPriority(1)
                
                ZStack {
                    if isOverlayColorVisible {
                        themeColor
                            .edgesIgnoringSafeArea(.bottom)
                            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                    }
                    
                    Text(text)
                        .foregroundColor(themeColor)
                        .font(.system(size: 30))
                        .multilineTextAlignment(.center)
                        .opacity(textOpacity)
                        .padding(.vertical, 10)
                        .transition(.opacity)
                }
                
            }
        }
        .onChange(of: isPresented) { isPresented in
            guard isPresented else { return }
            withAnimation(.easeInOut(duration: Configuration.showOverlayDuration)) {
                isOverlayColorVisible = true
            }
            withAnimation(.linear(duration: Configuration.hideOverlayShowTextDuration).delay(1.0)) {
                isOverlayColorVisible = false
                textOpacity = 1.0
            }
            withAnimation(.linear(duration: Configuration.hideTextDuration).delay(4.0)) {
                textOpacity = 0.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                self.isPresented = false
            }
        }
    }
    
    private enum Configuration {
        static let showOverlayDuration: TimeInterval = 1.0
        static let hideOverlayShowTextDuration: TimeInterval = 1.0
        static let hideTextDuration: TimeInterval = 0.5
    }
}

// MARK: - ViewModifier

extension View {
    func recordOverlay(text: String, _ isPresented: Binding<Bool>) -> some View {
        modifier(OverlayAnimationViewModifier(text: text, isPresented: isPresented))
    }
}

// MARK: - Preview View

struct SampleView: View {
    @State var showOverlay: Bool = false
    
    var body: some View {
        TabView {
            Button("Tap to see animation") {
                showOverlay = true
            }
            .buttonStyle(.automatic)
            .tabItem {
                Text("xd")
            }
        }
        .recordOverlay(text: "Hello :)", $showOverlay)
        .preferredColorScheme(.dark)
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
