//
//  UserManager.swift
//  realday
//
//  Created by Johann Petzold on 16/01/2025.
//

import Foundation
import SwiftUI
import OSLog
import Models

// MARK: Logger

fileprivate let logger: Logger = .init(subsystem: "RealDay", category: "User Manager")

// MARK: User Manager

class UserManager: ObservableObject {
    
    @Published var user: User?
}
