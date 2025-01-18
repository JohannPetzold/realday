//
//  SearchViewModel.swift
//  realday
//
//  Created by Johann Petzold on 18/01/2025.
//

import Foundation
import Models

// MARK: - Search View Model

class SearchViewModel: ObservableObject {
    
    // MARK: Published
    
    @Published var search: String = ""
    @Published var searchUsers: [User] = []
    
    // MARK: Methods
    
    func updateSearchUsers() -> Void {
        if search.isEmpty {
            searchUsers = []
        } else if AppManager.shared.users.count > 0 {
            Task.detached {
                let randomSearch = Int.random(in: 0..<AppManager.shared.users.count)
                let randomUsers = Array(AppManager.shared.users.shuffled().prefix(randomSearch))
                await MainActor.run {
                    self.searchUsers = randomUsers
                }
            }
        }
    }
}
