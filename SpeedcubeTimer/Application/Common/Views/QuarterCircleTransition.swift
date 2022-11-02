//
//  QuarterCircleTransition.swift
//  SpeedcubeTimer
//
//  Created by Kacper on 28/08/2022.
//

import SwiftUI

struct ClipContentModifier<T: Shape>: ViewModifier {
    let shape: T
    
    func body(content: Content) -> some View {
        content
            .clipShape(shape)
            .contentShape(shape)
    }
}

// MARK: - Quarter Circle transition

extension AnyTransition {
    static var quarterCircle: AnyTransition {
        .modifier(active: ClipContentModifier(shape: OverlayFilledCircle(animationProgress: 0)),
                  identity: ClipContentModifier(shape: OverlayFilledCircle(animationProgress: 1)))
    }
}

private struct OverlayFilledCircle: Shape {
    var animationProgress: Double
    
    func path(in rect: CGRect) -> Path {
        let maxRadius = rect.maxY*1.5
        let start = CGPoint(x: rect.minX, y: rect.minY)
        
        var path = Path()
        
        path.move(to: start)
        path.addLine(to: CGPoint(x: maxRadius * animationProgress, y: rect.minY))
        path.addArc(center: start, radius: maxRadius * animationProgress, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.addLine(to: start)
        return path
    }
    
    var animatableData: Double {
        get { animationProgress }
        set { animationProgress = newValue }
    }
}
