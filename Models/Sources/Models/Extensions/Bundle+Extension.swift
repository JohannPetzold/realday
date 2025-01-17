//
//  Bundle+Extension.swift
//  Models
//
//  Created by Johann Petzold on 17/01/2025.
//

import Foundation

extension Bundle {
    
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T? {
        guard let url = self.url(forResource: file, withExtension: "json") else {
            print("Failed to locate \(file) in bundle.")
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            print("Failed to load \(file) from bundle.")
            return nil
        }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Failed to decode \(file): \(error)")
            return nil
        }
    }
}
