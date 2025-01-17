//
//  TitleTextField.swift
//  DesignSystem
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI

// MARK: - Title Text Field

public struct TitleTextField: View {
    
    // MARK: Properties
    
    @Binding private var text: String
    private let title: String?
    private let placeholder: String?
    private let secure: Bool
    private let isValid: Bool
    private let isError: Bool
    private let message: String?
    
    // MARK: Init
    
    public init(text: Binding<String>, title: String?, placeholder: String?, secure: Bool, isValid: Bool, isError: Bool, message: String?) {
        self._text = text
        self.title = title
        self.placeholder = placeholder
        self.secure = secure
        self.isValid = isValid
        self.isError = isError
        self.message = message
    }
    
    // MARK: Layout
    
    public var body: some View {
        VStack(spacing: .DesignSystem.Spacing.s) {
         
            if let title {
                
                Text(title)
                    .font(.DesignSystem.sub1(weight: .bold))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, .DesignSystem.Spacing.s)
                
            }
            
            HStack(spacing: 0) {
                
                if secure {
                    
                    SecureField(placeholder ?? "", text: $text)
                        .font(.DesignSystem.body1(weight: .medium))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                } else {
                    
                    TextField(placeholder ?? "", text: $text)
                        .font(.DesignSystem.body1(weight: .medium))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                
            }
            .padding(.horizontal, .DesignSystem.Spacing.l)
            .padding(.vertical, .DesignSystem.Spacing.m)
            .frame(maxWidth: .infinity)
            .frame(height: 46)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor(), lineWidth: 1)
            )
            
            if let message {
                
                Text(message)
                    .font(.DesignSystem.body2(weight: .medium))
                    .foregroundStyle(messageColor())
                    .multilineTextAlignment(.center)
                    .transition(.asymmetric(insertion: .opacity.animation(.easeIn(duration: 0.3)), removal: .opacity.animation(.easeIn(duration: 0))))
                
            }
            
        }
    }
    
    // MARK: Privates
    
    private func borderColor() -> Color {
        isError ? .red : .primary
    }
    
    private func messageColor() -> Color {
        isError ? .red : .primary
    }
    
    // MARK: Actions
    
}

#Preview {
    VStack(spacing: .DesignSystem.Spacing.l) {
        
        TitleTextField(
            text: .constant(""),
            title: "First Name",
            placeholder: "John",
            secure: false,
            isValid: false,
            isError: true,
            message: "Test"
        )
        
    }
    .padding(.horizontal, .DesignSystem.Spacing.l)
}
