//
//  AppManager.swift
//  realday
//
//  Created by Johann Petzold on 17/01/2025.
//

import Foundation
import SwiftUI
import OSLog
import Models

// MARK: - Logger

fileprivate let logger: Logger = .init(subsystem: "RealDay", category: "AppManager")

// MARK: - App Manager

class AppManager: ObservableObject {
    
    // MARK: Singleton
    
    static let shared: AppManager = AppManager()
    
    // MARK: Init
    
    init() {
        initDatas()
    }
    
    // MARK: Published
    
    @Published var usersFollowed: [User] = []
    @Published var users: [User] = []
    
    // MARK: Methods
    
    func initDatas() -> Void {
        let randomUserCount = Int.random(in: 20..<50)
        var users: [User] = []
        for _ in 0..<randomUserCount {
            var newUser = User.randomUser()
            newUser.posts = Post.randomPosts(count: Int.random(in: 1..<20))
            users.append(newUser)
        }
        self.users = users
        
        let followedCount = Int.random(in: 4...randomUserCount)
        self.usersFollowed = Array(users.shuffled().prefix(followedCount))
    }
}
