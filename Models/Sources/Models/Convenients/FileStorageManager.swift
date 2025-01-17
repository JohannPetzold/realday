//
//  FileStorageManager.swift
//  Models
//
//  Created by Johann Petzold on 17/01/2025.
//

import Foundation
import OSLog

// MARK: - Logger

fileprivate let logger: Logger = .init(subsystem: "RealDay", category: "FileStorageManager")

// MARK: - FileStorage Manager

@MainActor
public class FileStorageManager {
    
    // MARK: FileManager
    
    private static var filemanager = FileManager.default
    
    // MARK: Methods
    
    public static func getFileFromTmp(filename: String) -> URL? {
        let tmpUrl = filemanager.temporaryDirectory
        let fileUrl = tmpUrl.appendingPathComponent("\(filename)")
        if fileUrl.pathExtension.isEmpty {
            guard let urls = try? filemanager.contentsOfDirectory(at: tmpUrl, includingPropertiesForKeys: nil, options: []) else { return nil }
            let filesUrl = urls.filter { url in
                !url.hasDirectoryPath && url.deletingPathExtension().lastPathComponent == filename
            }
            return filesUrl.first
        } else {
            guard filemanager.fileExists(atPath: fileUrl.path) else { return nil }
        }
        logger.debug("Getting file \(filename) from url \(fileUrl)")
        return fileUrl
    }
    
    public static func saveFileInTmp(data: Data, filename: String, ext: String? = nil) throws -> URL {
        var destinationUrl = filemanager.temporaryDirectory.appendingPathComponent(filename)
        if let ext {
            destinationUrl = destinationUrl.appendingPathExtension(ext)
        }
        try data.write(to: destinationUrl, options: .atomic)
        logger.debug("Saving file \(filename) to url \(destinationUrl)")
        return destinationUrl
    }
    
    public static func deleteFile(url: URL) throws {
        guard filemanager.fileExists(atPath: url.path) else { return }
        try filemanager.removeItem(at: url)
    }
    
    public static func fileExist(at path: String) -> Bool {
        return filemanager.fileExists(atPath: path)
    }
    
    public static func clearTmp() throws {
        let tmpUrl = filemanager.temporaryDirectory
        let tmpDirectory = try filemanager.contentsOfDirectory(atPath: tmpUrl.path)
        try tmpDirectory.forEach { file in
            let fileUrl = tmpUrl.appendingPathComponent(file)
            if filemanager.fileExists(atPath: fileUrl.path) {
                try filemanager.removeItem(at: fileUrl)
            }
        }
    }
}
