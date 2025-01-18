//
//  NewPostViewModel.swift
//  realday
//
//  Created by Johann Petzold on 18/01/2025.
//

import Foundation
import SwiftUI
import Models

// MARK: - New Post View Model

class NewPostViewModel: ObservableObject {
    
    // MARK: Published
    
    @Published var caption: String = ""
    var captionMaxLenght: Int = 240
    @Published var image: UIImage? = nil
    @Published var isLoadingSave: Bool = false
    @Published var errorSaving: Bool = false
    
    // MARK: Methods
    
    func imageCompletion(result: Result<UIImage, Error>) -> Void {
        switch result {
        case .success(let image):
            self.image = image
        case .failure(_):
            // Error
            break
        }
    }
    
    @MainActor func savePost(_ completion: @escaping () -> Void) -> Void {
        errorSaving = false
        guard let image, let imageData = image.jpegData(compressionQuality: 0.8) else {
            errorSaving = true
            return
        }
        isLoadingSave = true
        do {
            let filename = UUID().uuidString
            let imageUrl = try FileStorageManager.saveFileInTmp(data: imageData, filename: filename, ext: "jpg")
            if UIImage(contentsOfFile: imageUrl.path) == nil {
                errorSaving = true
                isLoadingSave = false
            } else {
                let newPost = Post(id: UUID().uuidString, created: Date(), updated: Date(), pictureUrl: "\(filename).jpg", text: caption)
                DispatchQueue.main.async {
                    UserManager.shared.addNewPost(newPost)
                    self.isLoadingSave = false
                    completion()
                }
            }
        } catch {
            errorSaving = true
            isLoadingSave = false
        }
    }
}
