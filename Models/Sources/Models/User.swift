//
//  User.swift
//  Models
//
//  Created by Johann Petzold on 16/01/2025.
//

import Foundation

// MARK: - User

public struct User: Codable {

    // MARK: Properties
    
    public var id: String
    public var firstName: String
    public var lastName: String
    public var email: String
    public var profilePictureUrlString: String?
    
    // MARK: Init
    
    public init(id: String, firstName: String, lastName: String, email: String, profilePictureUrlString: String? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profilePictureUrlString = profilePictureUrlString
    }
}
