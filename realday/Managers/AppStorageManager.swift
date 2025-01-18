//
//  AppStorageManager.swift
//  realday
//
//  Created by Johann Petzold on 17/01/2025.
//

import Foundation
import SwiftUI
import Models
import OSLog

// MARK: - Logger

fileprivate let logger: Logger = .init(subsystem: "RealDay", category: "App Storage")

// MARK: - App Storage Manager

class AppStorageManager {
    
    // MARK: Singleton
    
    static let shared: AppStorageManager = AppStorageManager()
    
    private init() { }
    
    // MARK: App Storage
    
    @AppStorage(AppStorageKeys.user.rawValue) var user: Data = Data()
    
    // MARK: User
    
    func setUser(_ setUser: User?) {
        guard let setUser else {
            logger.notice("Parameter is nil, delete User from storage")
            user = Data()
            return
        }
        guard let userEncoded = try? JSONEncoder().encode(setUser) else {
            logger.error("Error when encoding User")
            return
        }
        user = userEncoded
        logger.notice("User successfully stored in storage")
    }
    
    func getUser() -> User? {
        guard let storedUser = try? JSONDecoder().decode(User.self, from: user) else {
            logger.error("No User in storage")
            return nil
        }
        logger.notice("Getting User from storage")
        return storedUser
    }
}
