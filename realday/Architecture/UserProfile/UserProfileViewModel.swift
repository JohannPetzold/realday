//
//  UserProfileViewModel.swift
//  realday
//
//  Created by Johann Petzold on 17/01/2025.
//

import Foundation
import Models
import UIKit

// MARK: - User Profile View Model

class UserProfileViewModel: ObservableObject {

    // MARK: Published
    
    @Published var filteredPosts: [[Post]] = []
    @Published var pictureUrl: String?
    @Published var isLoadingDatas: Bool = true
    @Published var errorCamera: Bool = false
    
    // MARK: Methods
    
    func initDatas(with user: User?) -> Void {
        isLoadingDatas = true
        pictureUrl = user?.profilePictureUrlString
        if let user, let posts = user.posts {
            filteredPosts = posts.groupedByDay()
        }
        isLoadingDatas = false
    }
    
    @MainActor func imageCompletion(result: Result<UIImage, Error>) -> Void {
        switch result {
        case .success(let image):
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                // Error
                return
            }
            do {
                let filename = UUID().uuidString
                let imageUrl = try FileStorageManager.saveFileInTmp(data: imageData, filename: filename, ext: "jpg")
                if UIImage(contentsOfFile: imageUrl.path) == nil {
                    // Error
                } else {
                    DispatchQueue.main.async {
                        self.pictureUrl = "\(filename).jpg"
                        UserManager.shared.user?.profilePictureUrlString = "\(filename).jpg"
                        AppStorageManager.shared.setUser(UserManager.shared.user)
                    }
                }
            } catch {
                // error
            }
        case .failure(_):
            break
        }
    }
}
