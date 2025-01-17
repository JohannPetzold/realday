//
//  LogInViewModel.swift
//  realday
//
//  Created by Johann Petzold on 16/01/2025.
//

import Foundation
import SwiftUI

// MARK: - Log In View Model

class LogInViewModel: ObservableObject {
    
    // MARK: Published
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var isErrorEmail: Bool = false
    @Published var isErrorPassword: Bool = false
    
    @Published var isLoadingLogIn: Bool = false
    @Published var errorLogIn: Bool = false
    
    // MARK: Methods
    
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
    
    func logIn() -> Void {
        isLoadingLogIn = true
        Task {
            do {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                await MainActor.run {
                    UserManager.shared.loginUser(email: email, password: password) {
                        self.errorLogIn = true
                    }
                    isLoadingLogIn = false
                }
            } catch {
                await MainActor.run {
                    isLoadingLogIn = false
                    errorLogIn = true
                }
            }
        }
    }
}
