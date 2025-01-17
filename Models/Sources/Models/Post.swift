//
//  Post.swift
//  Models
//
//  Created by Johann Petzold on 17/01/2025.
//

import Foundation

// MARK: - Post

public struct Post: Codable {
    
    // MARK: Properties
    
    public var id: String
    public let created: Date
    public var updated: Date
    public var pictureUrl: String
    public var text: String?
}
