//
//  LogIn.swift
//  realday
//
//  Created by Johann Petzold on 16/01/2025.
//

import SwiftUI
import DesignSystem

// MARK: - Log In

struct LogIn: View {
    
    // MARK: Properties
    
    @Binding var isPresented: Bool
    
    // MARK: States
    
    @StateObject var model: LogInViewModel = LogInViewModel()
    @State private var navBarHeight: CGFloat = 0
    @FocusState private var focusedField: Focus?
    @State private var fieldFocus: Bool = false
    
    private enum Focus: Int, Hashable {
        case email, password
    }
    
    var body: some View {
        ZStack {
            
            ImageButton(
                image: Image(systemName: "chevron.left"),
                color: .primary,
                contentMode: .fit,
                size: .init(width: 20, height: 26),
                action: onTapBack
            )
            .padding(.top, .DesignSystem.Spacing.m)
            .padding(.horizontal, .DesignSystem.Spacing.l)
            .heightRecorder { value in
                navBarHeight = value
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .ignoresSafeArea(.keyboard)
            
            VStack(spacing: 0) {
                
                Spacer(minLength: .DesignSystem.Spacing.s)
                
                Text("Welcome back")
                    .font(.DesignSystem.h2(weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, .DesignSystem.Spacing.xxl)
                
                Spacer(minLength: .DesignSystem.Spacing.s)
                
                VStack(spacing: .DesignSystem.Spacing.xl) {
                    
                    VStack(spacing: .DesignSystem.Spacing.m) {
                        
                        TitleTextField(
                            text: $model.email,
                            title: "Email",
                            placeholder: "john@doe.com",
                            secure: false,
                            isValid: false,
                            isError: model.isErrorEmail,
                            message: nil
                        )
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .focused($focusedField, equals: .email)
                        .onSubmit {
                            focusedField = .password
                        }
                        .onTapGesture {
                            focusedField = .email
                        }
                        
                        TitleTextField(
                            text: $model.password,
                            title: "Password",
                            placeholder: "",
                            secure: true,
                            isValid: false,
                            isError: model.isErrorPassword,
                            message: nil
                        )
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.default)
                        .textContentType(.password)
                        .focused($focusedField, equals: .password)
                        .onSubmit {
                            focusedField = nil
                        }
                        .onTapGesture {
                            focusedField = .password
                        }
                        
                    }
                    
                    TextButton(
                        text: "Log In",
                        type: .blue,
                        font: .DesignSystem.body1(weight: .bold),
                        isLoading: model.isLoadingLogIn,
                        disabled: disableLogIn(),
                        action: onTapLogIn
                    )
                    
                }
                .padding(.horizontal, .DesignSystem.Spacing.l)
                .padding(.bottom, .DesignSystem.Spacing.xxl)
                
                Spacer(minLength: .DesignSystem.Spacing.s)
                
            }
            .padding(.top, navBarHeight)
        }
        .contentShape(Rectangle())
        .toolbar(.hidden)
        .onTapGesture {
            fieldFocus = false
        }
        .onChange(of: focusedField) { oldValue, newValue in
            if newValue != nil {
                fieldFocus = true
            }
            if newValue != .email {
                model.checkEmailValidity()
            }
            if newValue != .password {
                model.checkPasswordValidity()
            }
        }
        .onChange(of: fieldFocus) { oldValue, newValue in
            if !newValue {
                focusedField = nil
            }
        }
        .onChange(of: model.email) { oldValue, newValue in
            if model.isErrorEmail {
                withAnimation(.easeOut(duration: 0.2)) {
                    model.isErrorEmail = false
                }
            }
        }
        .onChange(of: model.password) { oldValue, newValue in
            if model.isErrorPassword {
                withAnimation(.easeOut(duration: 0.2)) {
                    model.isErrorPassword = false
                }
            }
        }
    }
    
    // MARK: Privates
    
    private func disableLogIn() -> Bool {
        let emailValid = !model.email.isEmpty && !model.isErrorEmail
        let passwordValid = !model.password.isEmpty && !model.isErrorPassword
        
        return !emailValid || !passwordValid
    }
    
    // MARK: Actions
    
    private func onTapBack() -> Void {
        isPresented = false
    }
    
    private func onTapLogIn() -> Void {
        focusedField = nil
        model.logIn()
    }
}

// MARK: - Previews

#Preview {
    LogIn(isPresented: .constant(true))
}
