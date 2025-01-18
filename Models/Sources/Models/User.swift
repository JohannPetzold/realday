//
//  User.swift
//  Models
//
//  Created by Johann Petzold on 16/01/2025.
//

import Foundation

// MARK: - User

public struct User: Codable, Sendable, Hashable, Identifiable {

    // MARK: Properties
    
    public var id: String
    public var firstName: String
    public var lastName: String
    public var email: String
    public var password: String // Local
    public var profilePictureUrlString: String?
    public var posts: [Post]?
    
    // MARK: Init
    
    public init(id: String, firstName: String, lastName: String, email: String, password: String, profilePictureUrlString: String? = nil, posts: [Post]? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.profilePictureUrlString = profilePictureUrlString
        self.posts = posts
    }
    
    public static func randomUser() -> User {
        // Load users from JSON
        guard let url = Bundle.module.url(forResource: "random_users", withExtension: "json"),
              let users: [User] = Bundle.module.decode([User].self, from: url) else {
            fatalError("Could not load users from JSON.")
        }
        
        // Select a random user
        guard var randomUser = users.randomElement() else {
            fatalError("No users available in JSON.")
        }
        
        randomUser.id = UUID().uuidString
        return randomUser
    }
}
