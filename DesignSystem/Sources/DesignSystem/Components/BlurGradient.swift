//
//  BlurGradient.swift
//  DesignSystem
//
//  Created by Johann Petzold on 18/01/2025.
//

import SwiftUI

// MARK: - Blur Gradient

public struct BlurGradient: View {
    
    // MARK: Properties
    
    private let height: CGFloat
    private let reduceOpacity: Bool
    private let colors: [Color]
    
    // MARK: Init
    
    public init(
        height: CGFloat = 0,
        reduceOpacity: Bool = false,
        colors: [Color] = [
            Color.white.opacity(0),
            Color.white.opacity(0.162),
            Color.white.opacity(0.383),
            Color.white.opacity(0.707),
            Color.white.opacity(0.924),
            Color.white
        ]
    ) {
        self.height = height
        self.reduceOpacity = reduceOpacity
        self.colors = colors
    }
    
    // MARK: Layout
    
    public var body: some View {
        GeometryReader { geometry in
            BlurEffect(style: .dark)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .mask {
                    VStack(spacing: 0) {
                        
                        Spacer()
                        
                        LinearGradient(
                            colors: colors,
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: height)
                    }
                }
                .opacity(reduceOpacity ? 0.6 : 1)
        }
    }
}
