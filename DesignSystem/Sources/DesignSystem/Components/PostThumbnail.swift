//
//  PostThumbnail.swift
//  DesignSystem
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI
import Models

// MARK: - Post Thumbnail

public struct PostThumbnail: View {
    
    // MARK: Properties
    
    private let post: Post
    private let action: (() -> Void)?
    
    // MARK: States
    
    @State private var image: Image? = nil
    @State private var uiImage: UIImage? = nil
    @State private var isLoadingImage: Bool = false
    @State private var errorLoadingImage: Bool = false
    
    // MARK: Init
    
    public init(post: Post, action: (() -> Void)?) {
        self.post = post
        self.action = action
    }
    
    // MARK: Layout
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.clear)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Group {
                    if isLoadingImage {
                        
                        Rectangle()
                            .foregroundStyle(Color.DesignSystem.skeletonBackground)
                        
                    } else if let image {
                        
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                    } else {
                        
                        Rectangle()
                            .foregroundStyle(Color.DesignSystem.skeletonBackground)
                        
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.primary)
                        
                    }
                }
            )
            .onAppear(perform: onAppear)
            .aspectRatio(.init(width: 240, height: 388), contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .contentShape(RoundedRectangle(cornerRadius: 8))
            .onTapGesture(perform: onTap)
    }
    
    // MARK: Privates
    
    private func onAppear() -> Void {
        self.isLoadingImage = true
        Task.detached {
            if let uiImage = await NSCacheManager.shared.getImage(name: post.pictureUrl) {
                let image = Image(uiImage: uiImage)
                await MainActor.run {
                    self.uiImage = uiImage
                    self.image = image
                    self.isLoadingImage = false
                }
            } else if let localUrl = await FileStorageManager.getFileFromTmp(filename: post.pictureUrl), let imageData = try? Data(contentsOf: localUrl), let uiImage = UIImage(data: imageData) {
                await NSCacheManager.shared.add(image: uiImage, name: post.pictureUrl)
                let image = Image(uiImage: uiImage)
                await MainActor.run {
                    self.uiImage = uiImage
                    self.image = image
                    self.isLoadingImage = false
                }
            } else if let imageUrl = Bundle.module.url(forResource: post.pictureUrl, withExtension: "jpg"), let imageData = try? Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
                let image = Image(uiImage: uiImage)
                await MainActor.run {
                    self.uiImage = uiImage
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
    VStack(spacing: .DesignSystem.Spacing.l) {
        
        PostThumbnail(post: .randomPost(), action: nil)
        
        PostThumbnail(post: .randomPost(), action: nil)
    }
}
