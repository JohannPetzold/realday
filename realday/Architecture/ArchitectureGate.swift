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
    
    @EnvironmentObject var userManager: UserManager
    
    // MARK: Layout
    
    var body: some View {
        Group {
            
            if userManager.user == nil {
                
                Onboarding()
                
            } else {
                
                
                
            }
        }
    }
}

// MARK: - Previews

#Preview {
    ArchitectureGate()
}
