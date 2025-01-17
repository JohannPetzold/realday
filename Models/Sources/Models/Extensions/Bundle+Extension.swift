//
//  Bundle+Extension.swift
//  Models
//
//  Created by Johann Petzold on 17/01/2025.
//

import Foundation

extension Bundle {
    
    func decode<T: Decodable>(_ type: T.Type, from url: URL) -> T? {
        guard let data = try? Data(contentsOf: url) else {
            print("Failed to load \(url) from bundle.")
            return nil
        }
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Failed to decode \(url): \(error)")
            return nil
        }
    }
}
