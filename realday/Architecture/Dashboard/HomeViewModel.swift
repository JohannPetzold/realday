//
//  HomeViewModel.swift
//  realday
//
//  Created by Johann Petzold on 17/01/2025.
//

import Foundation
import Models

// MARK: - Home View Model

class HomeViewModel: ObservableObject {
    
    // MARK: Singleton
    
    static let shared: HomeViewModel = HomeViewModel()
    
    // MARK: Init
    
    fileprivate init() {
        initDatas()
    }
    
    // MARK: Published
    
    @Published var dayUsers: [User] = []
    
    // MARK: Methods
    
    fileprivate func initDatas() -> Void {
        dayUsers = AppManager.shared.usersFollowed.filter({ user in
            guard let posts = user.posts, !posts.filter({ $0.created > Date().addingTimeInterval(-86400) }).isEmpty else {
                return false
            }
            return true
        })
    }
}
