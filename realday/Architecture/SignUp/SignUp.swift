//
//  SignUp.swift
//  realday
//
//  Created by Johann Petzold on 16/01/2025.
//

import SwiftUI
import DesignSystem

// MARK: - Sign Up

struct SignUp: View {
    
    // MARK: Properties
    
    @Binding var isPresented: Bool
    
    // MARK: States
    
    @StateObject var model: SignUpViewModel = SignUpViewModel()
    @State private var navBarHeight: CGFloat = 0
    @FocusState private var focusedField: Focus?
    @State private var fieldFocus: Bool = false
    
    private enum Focus: Int, Hashable {
        case firstName, lastName, email, password
    }
    
    // MARK: Layout
    
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
                
                VStack(spacing: .DesignSystem.Spacing.l) {
                    
                    Text("Welcome")
                        .font(.DesignSystem.h2(weight: .bold))
                        .foregroundStyle(.primary)
                    
                    Text("Create an account to start your RealDay experience")
                        .font(.DesignSystem.body1(weight: .medium))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                    
                }
                .padding(.horizontal, .DesignSystem.Spacing.xxl)
                
                Spacer(minLength: .DesignSystem.Spacing.s)
                
                VStack(spacing: .DesignSystem.Spacing.xl) {
                    
                    VStack(spacing: .DesignSystem.Spacing.m) {
                        
                        HStack(spacing: .DesignSystem.Spacing.l) {
                            
                            TitleTextField(
                                text: $model.firstName,
                                title: "First Name",
                                placeholder: "John",
                                secure: false,
                                isValid: false,
                                isError: model.isErrorFirstName,
                                message: nil
                            )
                            .autocorrectionDisabled()
                            .keyboardType(.default)
                            .textContentType(.givenName)
                            .focused($focusedField, equals: .firstName)
                            .onSubmit {
                                focusedField = .lastName
                            }
                            .onTapGesture {
                                focusedField = .firstName
                            }
                            
                            TitleTextField(
                                text: $model.lastName,
                                title: "Last Name",
                                placeholder: "Doe",
                                secure: false,
                                isValid: false,
                                isError: model.isErrorLastName,
                                message: nil
                            )
                            .autocorrectionDisabled()
                            .keyboardType(.default)
                            .textContentType(.familyName)
                            .focused($focusedField, equals: .lastName)
                            .onSubmit {
                                focusedField = .email
                            }
                            .onTapGesture {
                                focusedField = .lastName
                            }
                            
                        }
                        
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
                    
                    if focusedField == nil && !disableSignUp() {
                        
                        TextButton(
                            text: "Sign Up",
                            type: .blue,
                            font: .DesignSystem.body1(weight: .bold),
                            isLoading: model.isLoadingSignUp,
                            disabled: disableSignUp(),
                            action: onTapSignUp
                        )
                        
                    }
                    
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
            if newValue != .firstName {
                model.checkFirstNameValidity()
            }
            if newValue != .lastName {
                model.checkLastNameValidity()
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
        .onChange(of: model.firstName) { oldValue, newValue in
            if model.isErrorFirstName {
                withAnimation(.easeOut(duration: 0.2)) {
                    model.isErrorFirstName = false
                }
            }
        }
        .onChange(of: model.lastName) { oldValue, newValue in
            if model.isErrorLastName {
                withAnimation(.easeOut(duration: 0.2)) {
                    model.isErrorLastName = false
                }
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
    
    private func disableSignUp() -> Bool {
        let firstNameValid = !model.firstName.isEmpty && !model.isErrorFirstName
        let lastNameValid = !model.lastName.isEmpty && !model.isErrorLastName
        let emailValid = !model.email.isEmpty && !model.isErrorEmail
        let passwordValid = !model.password.isEmpty && !model.isErrorPassword
        
        return !firstNameValid || !lastNameValid || !emailValid || !passwordValid
    }
    
    // MARK: Actions
    
    private func onTapBack() -> Void {
        isPresented = false
    }
    
    private func onTapSignUp() -> Void {
        focusedField = nil
        model.signUp()
    }
}

// MARK: - Previews

#Preview {
    SignUp(isPresented: .constant(true))
}
