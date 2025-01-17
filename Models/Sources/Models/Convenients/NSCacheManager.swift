//
//  NSCacheManager.swift
//  Models
//
//  Created by Johann Petzold on 17/01/2025.
//

import Foundation
import SwiftUI
import OSLog

// MARK: - Logger

fileprivate let logger: Logger = .init(subsystem: "RealDay", category: "NSCacheManager")

// MARK: - Image Manager

@MainActor
public class NSCacheManager {
    
    public static let shared = NSCacheManager()
    
    private init() { }
    
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString,UIImage> ()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    
    public func add(image: UIImage,name: String) -> Void {
        imageCache.setObject(image, forKey: name as NSString)
    }
    
    public func getImage(name: String) -> UIImage? {
        guard let image = imageCache.object(forKey: name as NSString) else {
            return nil
        }
        return image
    }
    
    public func remove(name: String) -> Void {
        imageCache.removeObject(forKey: name as NSString)
    }
}
