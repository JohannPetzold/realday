//
//  DashboardGate.swift
//  realday
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI

// MARK: - Dashboard Gate

struct DashboardGate: View {
    
    // MARK: States
    
    @StateObject var userManager: UserManager = .shared
    @StateObject var appManager: AppManager = .shared
    
    // MARK: Layout
    
    var body: some View {
        TabView(selection: $userManager.selectedIndex) {
            
            Tab("Home", systemImage: "house", value: 0) {
                Home()
            }
            
            Tab("", systemImage: "camera", value: 1) {
                VStack(spacing: 0) {
                    Text("Camera")
                }
            }
            
//            VStack(spacing: 0) {
//                
//                Text("New picture")
//                
//            }
//            .tag(1)
        }
//        VStack(spacing: .DesignSystem.Spacing.l) {
//         
//            Button {
//                userManager.disconnect()
//            } label: {
//                Text("Disconnect")
//            }
//            
//            Spacer()
//            
//            
//            
//        }

    }
}

// MARK: - Previews

#Preview {
    DashboardGate()
}
