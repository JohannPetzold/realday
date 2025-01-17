//
//  TextPlaceholder.swift
//  DesignSystem
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI

// MARK: - Text Placeholder

public struct TextPlaceholder: View {
    
    // MARK: Properties
    
    private var title: String?
    private var subtitle: String?
    private var buttonTitle: String?
    private var action: (() -> Void)?
    
    // MARK: Init
    
    public init(title: String? = nil, subtitle: String? = nil, buttonTitle: String? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        self.action = action
    }
    
    // MARK: Layout
    
    public var body: some View {
        VStack(spacing: .DesignSystem.Spacing.m) {
            
            if let title = title {
                
                Text(title)
                    .font(.DesignSystem.h3(weight: .bold))
                    .foregroundStyle(Color.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, .DesignSystem.Spacing.m)
                
            }
            
            if let subtitle = subtitle {
                
                Text(subtitle)
                    .font(.DesignSystem.body1(weight: .regular))
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, .DesignSystem.Spacing.m)
                
            }
            
            if let buttonTitle = buttonTitle {
                
                Text(buttonTitle)
                    .font(.DesignSystem.body1(weight: .medium))
                    .foregroundStyle(Color.blue)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, .DesignSystem.Spacing.xxl)
                
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, .DesignSystem.Spacing.xxl)
        .padding(.vertical, .DesignSystem.Spacing.xxxl)
        .background(Color.primary.colorInvert())
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .contentShape(RoundedRectangle(cornerRadius: 8))
        .onTapGesture(perform: onTapPlaceholder)
        .shadow(color: .DesignSystem.shadow, radius: 30, x: 0, y: 6)
    }
    
    // MARK: Privates
    
    // MARK: Actions
    
    private func onTapPlaceholder() -> Void {
        if let action = action {
            action()
        }
    }
}

// MARK: - Previews

#Preview {
    TextPlaceholder(
        title: "Something went wrong",
        subtitle: "Please come back later",
        buttonTitle: nil
    )
}
