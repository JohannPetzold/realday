//
//  Skeleton+Modifier.swift
//  DesignSystem
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI

// MARK: - Skeleton Modifier

extension View {
    
    @ViewBuilder public func skeleton(enabled: Bool = false, type: SkeletonType, frameColor: Color, cornerRadius: CGFloat = 0, animation: SkeletonAnimation = .pulse(color: Color.secondary, orientation: .horizontal)) -> some View {
        Group {
            if !enabled {
                self
            } else {
                switch type {
                case .text:
                    self
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .foregroundColor(frameColor)
                                .overlay(
                                    animation.body.mask(RoundedRectangle(cornerRadius: cornerRadius))
                                )
                        )
                case .line(let height):
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(frameColor)
                        .frame(maxWidth: .infinity, maxHeight: height)
                        .overlay(
                            animation.body
                                .mask(RoundedRectangle(cornerRadius: cornerRadius))
                        )
                case .customLine(let width, let height):
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(frameColor)
                        .frame(maxWidth: width, maxHeight: height)
                        .overlay(
                            animation.body
                                .mask(RoundedRectangle(cornerRadius: cornerRadius))
                        )
                case .circle:
                    Circle()
                        .foregroundColor(.clear)
                        .overlay(
                            Circle()
                                .foregroundColor(frameColor)
                                .overlay(
                                    animation.body
                                        .mask(Circle())
                                )
                        )
                case .background(let width, let height):
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(frameColor)
                        .frame(maxWidth: width, maxHeight: height)
                        .overlay(
                            animation.body.cornerRadius(cornerRadius)
                        )
                }
            }
        }
    }
}

// MARK: - Skeleton Type

public enum SkeletonType {
    case background(width: CGFloat, height: CGFloat)
    case circle
    case text
    case line(height: CGFloat)
    case customLine(width: CGFloat, height: CGFloat)
}

// MARK: - Skeleton Animation

public enum SkeletonAnimation: View {
    case pulse(color: Color, orientation: PulseSkeleton.AnimationOrientation)
    case opacity(color: Color)
    case none
    
    public var body: some View {
        switch self {
        case .pulse(let color, let orientation):
            PulseSkeleton(color: color, orientation: orientation)
        case .opacity(let color):
            OpacitySkeleton(color: color)
        case .none:
            EmptyView()
        }
    }
}

// MARK: - Animations

public struct PulseSkeleton: View {
    
    // MARK: Parameters
    
    let colors : [Color]
    let orientation: AnimationOrientation
    
    // MARK: States
    
    @State var start: UnitPoint
    @State var end: UnitPoint
    
    // MARK: Configuration
    
    let animationDuration: CGFloat = 1.8
    let pulseOpacity: CGFloat = 0.15
    
    // MARK: Orientation enum
    
    public enum AnimationOrientation {
        case horizontal
        case horizontalReversed
        case vertical
        case verticalReversed
        case topDiagonal
        case bottomDiagonal
        case topDiagonalReversed
        case bottomDiagonalReversed
        
        
        /// Get the start animation UnitPoint.
        func start() -> UnitPoint {
            switch self {
            case .horizontal:
                return UnitPoint(x: -3, y: 0)
            case .horizontalReversed:
                return UnitPoint(x: 3, y: 0)
            case .vertical:
                return UnitPoint(x: 0, y: -3)
            case .verticalReversed:
                return UnitPoint(x: 0, y: 3)
            case .topDiagonal:
                return UnitPoint(x: -3, y: -3)
            case .bottomDiagonal:
                return UnitPoint(x: -3, y: 3)
            case .topDiagonalReversed:
                return UnitPoint(x: 3, y: -3)
            case .bottomDiagonalReversed:
                return UnitPoint(x: 3, y: 3)
            }
        }
        
        /// Get the end animation UnitPoint.
        func end() -> UnitPoint {
            switch self {
            case .horizontal:
                return UnitPoint(x: -1, y: 0)
            case .horizontalReversed:
                return UnitPoint(x: 1, y: 0)
            case .vertical:
                return UnitPoint(x: 0, y: -1)
            case .verticalReversed:
                return UnitPoint(x: 0, y: 1)
            case .topDiagonal:
                return UnitPoint(x: -1, y: -1)
            case .bottomDiagonal:
                return UnitPoint(x: -1, y: 1)
            case .topDiagonalReversed:
                return UnitPoint(x: 1, y: -1)
            case .bottomDiagonalReversed:
                return UnitPoint(x: 1, y: 1)
            }
        }
    }
    
    // MARK: Init
    
    init(color: Color, orientation: AnimationOrientation) {
        self.colors = [Color.clear, color, Color.clear]
        self.orientation = orientation
        self.start = self.orientation.start()
        self.end = self.orientation.end()
    }
    
    // MARK: Layout
    
    public var body: some View {
        LinearGradient(colors: colors, startPoint: start, endPoint: end)
            .onAppear(perform: onAppear)
            .opacity(pulseOpacity)
    }
    
    private func onAppear() -> Void {
        withAnimation(.easeInOut(duration: animationDuration).repeatForever(autoreverses: false)) {
            start = UnitPoint(x: orientation.end().x * -1, y: orientation.end().y * -1)
            end = UnitPoint(x: orientation.start().x * -1, y: orientation.start().y * -1)
        }
    }
}

struct OpacitySkeleton: View {
    
    // MARK: Parameters
    
    let color: Color
    
    // MARK: States
    
    @State var opacity: CGFloat = 0
    
    // MARK: Configuration
    
    let animationDuration: CGFloat = 2
    let maxOpacity: CGFloat = 0.2
    
    // MARK: Init
    
    init(color: Color) {
        self.color = color
    }
    
    // MARK: Layout
    
    var body: some View {
        color
            .opacity(opacity)
            .onAppear(perform: onAppear)
    }
    
    private func onAppear() -> Void {
        withAnimation(.easeInOut(duration: animationDuration).repeatForever(autoreverses: true)) {
            opacity = maxOpacity
        }
    }
}
