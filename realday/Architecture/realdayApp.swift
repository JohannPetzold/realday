//
//  realdayApp.swift
//  realday
//
//  Created by Johann Petzold on 16/01/2025.
//

import SwiftUI

@main
struct realdayApp: App {
    
    @StateObject var userManager: UserManager = UserManager()
    
    var body: some Scene {
        WindowGroup {
            ArchitectureGate()
        }
        .environmentObject(userManager)
    }
}
