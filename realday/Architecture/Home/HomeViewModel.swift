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
    @Published var gridPosts: [TimePeriod: [Post]] = [:]
    @Published var displayType: DisplayType = .carousel
    
    // MARK: Enums
    
    enum DisplayType {
        case carousel
        case grid
    }
    
    enum TimePeriod: String, CaseIterable {
        case yesterdayNight = "Yesterday Night"
        case yesterdayMorning = "Yesterday Morning"
        case yesterdayNoon = "Yesterday Noon"
        case yesterdayAfternoon = "Yesterday Afternoon"
        case yesterdayEvening = "Yesterday Evening"
        case lastNight = "Last Night"
        case morning = "Morning"
        case noon = "Noon"
        case afternoon = "Afternoon"
        case evening = "Evening"
    }
    
    // MARK: Methods
    
    private func initDatas() -> Void {
        dayUsers = AppManager.shared.usersFollowed.filter({ user in
            guard let posts = user.posts, !posts.filter({ $0.created > Date().addingTimeInterval(-86400) }).isEmpty else {
                return false
            }
            return true
        })
        initPosts()
    }
    
    private func initPosts() -> Void {
        let calendar = Calendar.current
        let now = Date()
        let last24HoursStart = calendar.date(byAdding: .hour, value: -24, to: now)!
        
        // Définir les plages horaires dynamiquement
        let todayStart = calendar.startOfDay(for: now)
        let yesterdayStart = calendar.date(byAdding: .day, value: -1, to: todayStart)!
        
        // Périodes possibles dans une journée
        let timeRanges: [(period: TimePeriod, range: (start: Date, end: Date))] = [
            (.yesterdayNight, (start: yesterdayStart, end: calendar.date(byAdding: .hour, value: 6, to: yesterdayStart)!)),
            (.yesterdayMorning, (start: calendar.date(byAdding: .hour, value: 6, to: yesterdayStart)!, end: calendar.date(byAdding: .hour, value: 11, to: yesterdayStart)!)),
            (.yesterdayNoon, (start: calendar.date(byAdding: .hour, value: 11, to: yesterdayStart)!, end: calendar.date(byAdding: .hour, value: 13, to: yesterdayStart)!)),
            (.yesterdayAfternoon, (start: calendar.date(byAdding: .hour, value: 13, to: yesterdayStart)!, end: calendar.date(byAdding: .hour, value: 18, to: yesterdayStart)!)),
            (.yesterdayEvening, (start: calendar.date(byAdding: .hour, value: 18, to: yesterdayStart)!, end: calendar.date(byAdding: .hour, value: 23, to: yesterdayStart)!)),
            // Dernière nuit
            (.lastNight, (start: calendar.date(byAdding: .hour, value: 23, to: yesterdayStart)!, end: calendar.date(byAdding: .hour, value: 6, to: todayStart)!)),
            // Aujourd'hui
            (.morning, (start: calendar.date(byAdding: .hour, value: 6, to: todayStart)!, end: calendar.date(byAdding: .hour, value: 11, to: todayStart)!)),
            (.noon, (start: calendar.date(byAdding: .hour, value: 11, to: todayStart)!, end: calendar.date(byAdding: .hour, value: 13, to: todayStart)!)),
            (.afternoon, (start: calendar.date(byAdding: .hour, value: 13, to: todayStart)!, end: calendar.date(byAdding: .hour, value: 18, to: todayStart)!)),
            (.evening, (start: calendar.date(byAdding: .hour, value: 18, to: todayStart)!, end: calendar.date(byAdding: .hour, value: 23, to: todayStart)!))
        ]
        
        // Filtrer les périodes qui tombent dans les dernières 24 heures
        let filteredTimeRanges = timeRanges.filter { $0.range.end > last24HoursStart && $0.range.start < now }
        
        // Récupérer tous les posts des utilisateurs suivis
        let allPosts = AppManager.shared.usersFollowed.compactMap { user in
            user.posts
        }.flatMap { $0 }
        
        // Remplir le dictionnaire en triant les posts par période
        gridPosts = filteredTimeRanges.reduce(into: [:]) { result, timeRange in
            let postsInRange = allPosts.filter { post in
                post.created >= timeRange.range.start && post.created < timeRange.range.end
            }
            result[timeRange.period] = postsInRange
        }
    }
    
    func sortedTimePeriods() -> [TimePeriod] {
        let now = Date()
        let calendar = Calendar.current
        
        // Calculer le milieu de chaque plage horaire pour effectuer un tri
        let timeRanges = gridPosts.keys.map { period -> (TimePeriod, Date?) in
            guard let posts = gridPosts[period], !posts.isEmpty else { return (period, nil) }
            let firstPostDate = posts.first?.created ?? calendar.startOfDay(for: now)
            return (period, firstPostDate)
        }
        
        // Trier les périodes par la date la plus proche de "maintenant"
        return timeRanges.compactMap { $0.1 != nil ? $0 : nil }
            .sorted { abs($0.1!.timeIntervalSince(now)) < abs($1.1!.timeIntervalSince(now)) }
            .map { $0.0 }
    }
}
