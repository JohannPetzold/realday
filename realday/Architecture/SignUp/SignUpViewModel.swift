//
//  SignUpViewModel.swift
//  realday
//
//  Created by Johann Petzold on 16/01/2025.
//

import Foundation
import Models
import SwiftUI

// MARK: - Sign Up View Model

class SignUpViewModel: ObservableObject {

    // MARK: Published
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var isErrorFirstName: Bool = false
    @Published var isErrorLastName: Bool = false
    @Published var isErrorEmail: Bool = false
    @Published var isErrorPassword: Bool = false
    
    @Published var isLoadingSignUp: Bool = false
    @Published var errorSignUp: Bool = false
    
    // MARK: Methods
    
    func checkFirstNameValidity() -> Void {
        if firstName != "" && !firstName.isValidFirstName() {
            withAnimation(.easeOut(duration: 0.2)) {
                isErrorFirstName = true
            }
        } else {
            withAnimation(.easeOut(duration: 0.2)) {
                isErrorFirstName = false
            }
        }
    }
    
    func checkLastNameValidity() -> Void {
        if lastName != "" && !lastName.isValidLastName() {
            withAnimation(.easeOut(duration: 0.2)) {
                isErrorLastName = true
            }
        } else {
            withAnimation(.easeOut(duration: 0.2)) {
                isErrorLastName = false
            }
        }
    }
    
    func checkEmailValidity() -> Void {
        if email != "" && !email.isValidEmail() {
            withAnimation(.easeOut(duration: 0.2)) {
                isErrorEmail = true
            }
        } else {
            withAnimation(.easeOut(duration: 0.2)) {
                isErrorEmail = false
            }
        }
    }
    
    func checkPasswordValidity() -> Void {
        if password != "" && password.count < 8 {
            withAnimation(.easeOut(duration: 0.2)) {
                isErrorPassword = true
            }
        } else {
            withAnimation(.easeOut(duration: 0.2)) {
                isErrorPassword = false
            }
        }
    }
    
    func signUp() -> Void {
        isLoadingSignUp = true
        Task {
            do {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                await MainActor.run {
                    isLoadingSignUp = false
                }
            } catch {
                await MainActor.run {
                    isLoadingSignUp = false
                    errorSignUp = true
                }
            }
        }
    }
}
