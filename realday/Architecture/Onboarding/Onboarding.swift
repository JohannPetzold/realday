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
    
    @StateObject var model: OnboardingViewModel = OnboardingViewModel()
    @State private var opacityAppearance: Bool = false
    @State private var buttonsAppearance: Bool = false
    @State private var presentSignUp: Bool = false
    @State private var presentLogIn: Bool = false
    
    // MARK: Layout
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: .DesignSystem.Spacing.l) {
                
                Spacer()
                
                VStack(spacing: .DesignSystem.Spacing.l) {
                    
                    Text("RealDay")
                        .font(.DesignSystem.h1(weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, .DesignSystem.Spacing.l)
                    
                    Text("Share your day with your friends!")
                        .font(.DesignSystem.subtitle1(weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, .DesignSystem.Spacing.l)
                    
                }
                .opacity(opacityAppearance ? 1 : 0)
                
                Spacer()
                    
                    VStack(spacing: .DesignSystem.Spacing.xxl) {
                        
                        VStack(spacing: .DesignSystem.Spacing.l) {
                            
                            TextButton(
                                text: "Sign Up",
                                type: .blur,
                                font: .DesignSystem.body1(weight: .bold),
                                isLoading: false,
                                disabled: false,
                                action: onTapSignUp
                            )
                            
                            Text("or")
                                .font(.DesignSystem.body1(weight: .medium))
                                .foregroundStyle(Color.white)
                            
                            TextButton(
                                text: "Sign In With Apple",
                                type: .signInWithApple,
                                font: .DesignSystem.body1(weight: .bold),
                                isLoading: false,
                                disabled: false,
                                action: {}
                            )
                            
                        }
                            
                        Button(action: onTapLogIn) {
                            HStack(spacing: .DesignSystem.Spacing.s) {
                                
                                Text("Already an account? Login")
                                    .foregroundStyle(.white)
                                    .font(.DesignSystem.body2(weight: .bold))
                                
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        
                    }
                    .padding(.horizontal, .DesignSystem.Spacing.l)
                    .padding(.bottom, .DesignSystem.Spacing.xxl)
                    .opacity(buttonsAppearance ? 1 : 0)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                BackgroundMesh()
                    .blur(radius: 4, opaque: true)
                    .ignoresSafeArea(.all)
            )
            .navigationDestination(isPresented: $presentSignUp) {
                SignUp(isPresented: $presentSignUp)
            }
            .navigationDestination(isPresented: $presentLogIn) {
                LogIn(isPresented: $presentLogIn)
            }
            
        }
        .onAppear(perform: onAppear)
        .onChange(of: opacityAppearance) { oldValue, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.easeOut(duration: 1.5)) {
                        self.buttonsAppearance = true
                    }
                }
            }
        }
    }
    
    // MARK: Privates
    
    private func onAppear() -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeOut(duration: 1)) {
                self.opacityAppearance = true
            }
        }
    }
    
    // MARK: Actions
    
    private func onTapSignUp() -> Void {
        presentSignUp = true
    }
    
    private func onTapLogIn() -> Void {
        presentLogIn = true
    }
}

// MARK: - Background Mesh

fileprivate struct BackgroundMesh: View {
    
    @State private var appear: Bool = false
    @State private var appear2: Bool = false
    
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                [0, 0],
                appear2 ? [0.5, 0] : [1, 0],
                [1, 0],
                [0, 0.5],
                appear ? [0.1, 0.5] : [0.8, 0.2],
                appear2 ? [1, 0.2] : [1, 0.5],
                [0, 1],
                appear2 ? [0.5, 1] : [1, 1],
                [1, 1]
            ],
            colors: [
                appear ? .red : .yellow,
                appear2 ? .blue : .orange,
                appear ? .purple : .blue,
                appear ? .orange : .purple,
                appear2 ? .red : .yellow,
                appear2 ? .purple : .blue,
                appear ? .blue : .yellow,
                appear ? .purple : .red,
                appear2 ? .orange : .red
            ]
        )
        .onAppear(perform: onAppear)
    }
    
    private func onAppear() -> Void {
        withAnimation(.easeOut(duration: TimeInterval.random(in: 4...7)).repeatForever(autoreverses: true)) {
            appear.toggle()
        }
        withAnimation(.easeOut(duration: TimeInterval.random(in: 4...7)).repeatForever(autoreverses: true)) {
            appear2.toggle()
        }
    }
}

// MARK: - Previews

#Preview {
    Onboarding()
}
