//
//  TextButton.swift
//  DesignSystem
//
//  Created by Johann Petzold on 16/01/2025.
//

import SwiftUI

// MARK: - Text Button

public struct TextButton: View {
    
    // MARK: Properties
    
    private let text: String
    private let type: ButtonType
    private let font: Font
    private let isLoading: Bool
    private let disabled: Bool
    private let action: (() -> Void)?
    
    // MARK: Enum
    
    public enum ButtonType {
        case blur
        case blue
        case signInWithApple
    }
    
    // MARK: Init
    
    public init(text: String, type: ButtonType, font: Font, isLoading: Bool, disabled: Bool, action: @escaping () -> Void) {
        self.text = text
        self.type = type
        self.font = font
        self.isLoading = isLoading
        self.disabled = disabled
        self.action = action
    }
    
    fileprivate init(text: String, type: ButtonType, font: Font, isLoading: Bool, disabled: Bool) {
        self.text = text
        self.type = type
        self.font = font
        self.isLoading = isLoading
        self.disabled = disabled
        self.action = nil
    }
    
    // MARK: Layout
    
    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: .DesignSystem.Spacing.s) {
                
                if let buttonImage = buttonImage() {
                    
                    buttonImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)

                }
                
                if isLoading {
                    
                    ProgressView()
                        .tint(textColor())
                    
                } else {
                 
                    Text(text)
                        .foregroundStyle(textColor())
                        .font(font)
                    
                }
            }
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(
                background()
            )
            .contentShape(RoundedRectangle(cornerRadius: 8))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .disabled(disabled || isLoading)
        .opacity(disabled ? 0.6 : 1)
    }
    
    // MARK: Privates
    
    private func textColor() -> Color {
        switch type {
        case .blur: return .white
        case .blue: return .white
        case .signInWithApple: return .black
        }
    }
    
    private func background() -> some View {
        Group {
            switch type {
            case .blur:
                BlurEffect(style: .light)
            case .blue:
                Color.blue
            case .signInWithApple:
                Color.white
            }
        }
    }
    
    private func buttonImage() -> Image? {
        switch type {
        case .blur: return nil
        case .blue: return nil
        case .signInWithApple:
            return .DesignSystem.appleIcon
        }
    }
    
    // MARK: Actions
    
    private func onTap() -> Void {
        if let action {
            action()
        }
    }
}

// MARK: - Previews

#Preview {
    VStack(spacing: .DesignSystem.Spacing.l) {
        
        TextButton(
            text: "Sign In",
            type: .blur,
            font: .DesignSystem.body1(weight: .bold),
            isLoading: false,
            disabled: false
        )
        
        TextButton(
            text: "Sign In",
            type: .blur,
            font: .DesignSystem.body1(weight: .bold),
            isLoading: true,
            disabled: false
        )
        
        TextButton(
            text: "Sign Up",
            type: .blue,
            font: .DesignSystem.body1(weight: .bold),
            isLoading: false,
            disabled: false
        )
        
        TextButton(
            text: "Sign In With Apple",
            type: .signInWithApple,
            font: .DesignSystem.body1(weight: .bold),
            isLoading: false,
            disabled: false
        )
        
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.horizontal, .DesignSystem.Spacing.l)
    .background(
        Color.secondary
    )
}
