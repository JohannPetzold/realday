//
//  BlurEffect+Representable.swift
//  DesignSystem
//
//  Created by Johann Petzold on 16/01/2025.
//

import Foundation
import SwiftUI

// MARK: - Blur Effect

public struct BlurEffect: UIViewRepresentable {
    
    private let style: UIBlurEffect.Style
    
    public init(style: UIBlurEffect.Style) {
        self.style = style
    }
    
    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        return UIVisualEffectView(effect: blurEffect)
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { }
}
