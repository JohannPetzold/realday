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

// MARK: - Logger

fileprivate let logger: Logger = .init(subsystem: "RealDay", category: "UserManager")

// MARK: - User Manager

class UserManager: ObservableObject {
    
    // MARK: Singleton
    
    static let shared: UserManager = UserManager()
    
    // MARK: Published
    
    @Published var user: User?
    @Published var selectedIndex: Int = 0
    
    // MARK: Init
    
    init() {
        self.user = AppStorageManager.shared.getUser()
    }
    // MARK: Methods
    
    func signUser(firstName: String, lastName: String, email: String, password: String) -> Void {
        self.user = User(id: UUID().uuidString, firstName: firstName, lastName: lastName, email: email, password: password)
        AppStorageManager.shared.setUser(self.user)
    }
    
    func signInWithApple() -> Void {
        self.user = .randomUser()
        self.user?.posts = Post.randomPosts(count: 4)
        AppStorageManager.shared.setUser(self.user)
    }
    
    func loginUser(email: String, password: String, _ emptyCompletion: @escaping () -> Void) -> Void {
        guard let storedUser = AppStorageManager.shared.getUser(),
              storedUser.email == email && storedUser.password == password else {
            emptyCompletion()
            return
        }
        self.user = storedUser
    }
    
    func disconnect() -> Void {
        self.user = nil
    }
}
