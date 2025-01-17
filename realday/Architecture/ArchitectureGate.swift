//
//  ArchitectureGate.swift
//  realday
//
//  Created by Johann Petzold on 16/01/2025.
//

import SwiftUI

// MARK: - Architecture Gate

struct ArchitectureGate: View {
    
    // MARK: Environments
    
    @StateObject var userManager: UserManager = .shared
    
    // MARK: Layout
    
    var body: some View {
        Group {
            
            if userManager.user == nil {
                
                Onboarding()
                
            } else {
                
                DashboardGate()
                
            }
        }
    }
}

// MARK: - Previews

#Preview {
    ArchitectureGate()
}
