//
//  ProfileButton.swift
//  DesignSystem
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI
import Models

// MARK: - Profile Button

public struct ProfileButton: View {
    
    // MARK: Properties
    
    private let pictureUrl: String?
    private let action: (() -> Void)?
    
    // MARK: States
    
    @State private var image: Image? = nil
    @State private var isLoadingImage: Bool = false
    @State private var errorLoadingImage: Bool = false
    
    // MARK: Init
    
    public init(pictureUrl: String?, action: @escaping () -> Void) {
        self.pictureUrl = pictureUrl
        self.action = action
    }
    
    fileprivate init(pictureUrl: String?) {
        self.pictureUrl = pictureUrl
        self.action = nil
    }
    
    // MARK: Layout
    
    public var body: some View {
        Button(action: onTap) {
            Circle()
                .skeleton(
                    enabled: isLoadingImage,
                    type: .circle,
                    frameColor: .DesignSystem.skeletonBackground,
                    cornerRadius: 100
                )
                .foregroundStyle(Color.DesignSystem.buttonBackground)
                .frame(width: 42, height: 42)
                .overlay {
                    Group {
                        
                        if isLoadingImage {
                            
                            EmptyView()
                            
                        } else if let image {
                            
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                            
                        } else {
                            
                            Image(systemName: "person")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(Color.primary)
                            
                        }
                        
                    }
                }
                .clipShape(Circle())
                .contentShape(Circle())
        }
        .onAppear(perform: onAppear)
    }
    
    // MARK: Privates
    
    private func onAppear() -> Void {
        self.isLoadingImage = true
        Task.detached {
            if let pictureUrl, let uiImage = await NSCacheManager.shared.getImage(name: pictureUrl) {
                let image = Image(uiImage: uiImage)
                await MainActor.run {
                    self.image = image
                    self.isLoadingImage = false
                }
            } else if let pictureUrl, let localUrl = await FileStorageManager.getFileFromTmp(filename: pictureUrl), let imageData = try? Data(contentsOf: localUrl), let uiImage = UIImage(data: imageData) {
                await NSCacheManager.shared.add(image: uiImage, name: pictureUrl)
                let image = Image(uiImage: uiImage)
                await MainActor.run {
                    self.image = image
                    self.isLoadingImage = false
                }
            } else if let pictureUrl, let imageUrl = Bundle.module.url(forResource: pictureUrl, withExtension: "jpg"), let imageData = try? Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
                let image = Image(uiImage: uiImage)
                await MainActor.run {
                    self.image = image
                    self.isLoadingImage = false
                }
            } else {
                await MainActor.run {
                    self.errorLoadingImage = true
                    self.isLoadingImage = false
                }
            }
        }
    }
    
    // MARK: Actions
    
    private func onTap() -> Void {
        if let action {
            action()
        }
    }
}

// MARK: - Previews

#Preview {
    ProfileButton(pictureUrl: "profile1")
}
