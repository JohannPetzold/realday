//
//  DashboardGate.swift
//  realday
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI

// MARK: - Dashboard Gate

struct DashboardGate: View {
    
    @StateObject var userManager: UserManager = .shared
    
    var body: some View {
        Button {
            userManager.disconnect()
        } label: {
            Text("Disconnect")
        }

    }
}

// MARK: - Previews

#Preview {
    DashboardGate()
}
