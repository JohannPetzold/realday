//
//  OnboardingViewModel.swift
//  realday
//
//  Created by Johann Petzold on 16/01/2025.
//

import Foundation
import Models

// MARK: - Onboarding View Model

class OnboardingViewModel: ObservableObject {
    
    // MARK: Methods
    
    func signInWithApple() -> Void {
        UserManager.shared.signInWithApple()
    }
}
