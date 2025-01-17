//
//  Post.swift
//  Models
//
//  Created by Johann Petzold on 17/01/2025.
//

import Foundation

// MARK: - Post

public struct Post: Codable, Sendable, Equatable, Hashable {
    
    // MARK: Properties
    
    public var id: String
    public var created: Date
    public var updated: Date
    public var pictureUrl: String
    public var text: String?
    
    // MARK: Init
    
    public init(id: String, created: Date, updated: Date, pictureUrl: String, text: String? = nil) {
        self.id = id
        self.created = created
        self.updated = updated
        self.pictureUrl = pictureUrl
        self.text = text
    }
    
    // MARK: Methods
    
    public static func randomPost() -> Post {
        guard let url = Bundle.module.url(forResource: "random_posts", withExtension: "json"),
              let posts = Bundle.module.decode([Post].self, from: url) else {
            fatalError("Impossible de charger le fichier JSON.")
        }
        
        guard var randomPost = posts.randomElement() else {
            fatalError("Aucun post disponible.")
        }
        
        let now = Date()
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: now)!
        let randomCreatedDate = Date.randomDateBetween(start: threeDaysAgo, end: now)
        let randomUpdatedDate = Date.randomDateBetween(start: randomCreatedDate, end: now)
        
        randomPost.created = randomCreatedDate
        randomPost.updated = randomUpdatedDate
        
        return randomPost
    }
    
    public static func randomPosts(count: Int) -> [Post] {
        guard let url = Bundle.module.url(forResource: "random_posts", withExtension: "json"),
              let posts = Bundle.module.decode([Post].self, from: url) else {
            fatalError("Impossible de charger le fichier JSON.")
        }
        
        guard !posts.isEmpty else {
            fatalError("Le fichier JSON ne contient aucun post.")
        }
        
        let now = Date()
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: now)!
        
        return (0..<count).compactMap { _ in
            guard var randomPost = posts.randomElement() else {
                return nil
            }
            
            let randomCreatedDate = Date.randomDateBetween(start: threeDaysAgo, end: now)
            let randomUpdatedDate = Date.randomDateBetween(start: randomCreatedDate, end: now)
            
            randomPost.created = randomCreatedDate
            randomPost.updated = randomUpdatedDate
            
            return randomPost
        }
    }
}

extension Array where Element == Post {
    
    public func groupedByDay() -> [[Post]] {
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: self) { post in
            calendar.startOfDay(for: post.created)
        }
        
        let sortedKeys = grouped.keys.sorted(by: >)
        
        return sortedKeys.map { grouped[$0] ?? [] }
    }
}
