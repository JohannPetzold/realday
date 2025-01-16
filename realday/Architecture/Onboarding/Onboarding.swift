//
//  Onboarding.swift
//  realday
//
//  Created by Johann Petzold on 16/01/2025.
//

import SwiftUI
import DesignSystem

// MARK: - Onboarding

struct Onboarding: View {
    
    // MARK: States
    
    @State private var opacityAppearance: Bool = false
    @State private var buttonsAppearance: Bool = false
    
    // MARK: Layout
    
    var body: some View {
        VStack(spacing: .DesignSystem.Spacing.l) {
            
            Spacer()
            
            VStack(spacing: .DesignSystem.Spacing.l) {
                
                Text("RealDay")
                    .font(.DesignSystem.h1(weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, .DesignSystem.Spacing.l)
                
                Text("Share your day with your friends!")
                    .font(.DesignSystem.subtitle1(weight: .medium))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, .DesignSystem.Spacing.l)
                
            }
            .opacity(opacityAppearance ? 1 : 0)
            
            Spacer()
            
            if buttonsAppearance {
                
                VStack(spacing: .DesignSystem.Spacing.xl) {
                    
                    Button(action: {}) {
                        Text("Sign Up")
                            .foregroundStyle(.primary)
                            .font(.DesignSystem.body1(weight: .bold))
                            .padding(.vertical, .DesignSystem.Spacing.l)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.primary, lineWidth: 1)
                            )
                            .contentShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                        
                    Button(action: {}) {
                        HStack(spacing: .DesignSystem.Spacing.s) {
                            
                            Text("Returning user?")
                                .foregroundStyle(.primary)
                                .font(.DesignSystem.body2(weight: .medium))
                            
                            Text("Login")
                                .foregroundStyle(.blue)
                                .font(.DesignSystem.body2(weight: .medium))
                            
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                }
                .padding(.horizontal, .DesignSystem.Spacing.l)
                .padding(.bottom, .DesignSystem.Spacing.xxl)
                
            }
            
        }
        .onAppear(perform: onAppear)
        .onChange(of: opacityAppearance) { oldValue, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.easeOut(duration: 1)) {
                        self.buttonsAppearance = true
                    }
                }
            }
        }
    }
    
    // MARK: Privates
    
    private func onAppear() -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeOut(duration: 1)) {
                self.opacityAppearance = true
            }
        }
    }
}

// MARK: - Previews

#Preview {
    Onboarding()
}
