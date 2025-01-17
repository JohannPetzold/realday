//
//  ProfilePictureLarge.swift
//  DesignSystem
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI
import Models

// MARK: - Profile Picture Large

public struct ProfilePictureLarge: View {
    
    // MARK: Properties
    
    private let pictureUrl: String?
    private let text: String
    private let action: (() -> Void)?
    
    // MARK: States
    
    @State private var image: Image? = nil
    @State private var isLoadingImage: Bool = false
    @State private var errorLoadingImage: Bool = false
    @State private var circleSize: CGSize = .init(width: 124, height: 124)
    @State private var iconSize: CGSize = .init(width: 38, height: 38)
    
    // MARK: Init
    
    public init(pictureUrl: String?, text: String, action: (() -> Void)?) {
        self.pictureUrl = pictureUrl
        self.text = text
        self.action = action
    }
    
    // MARK: Layout
    
    public var body: some View {
        VStack(spacing: .DesignSystem.Spacing.m) {
            
            if action != nil {
                
                Button(action: onTap) {
                    Circle()
                        .skeleton(
                            enabled: isLoadingImage,
                            type: .circle,
                            frameColor: .DesignSystem.skeletonBackground,
                            cornerRadius: 100
                        )
                        .foregroundStyle(Color.DesignSystem.buttonBackground)
                        .frame(width: circleSize.width, height: circleSize.height)
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
                                    
                                    Image(systemName: "camera")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: iconSize.width, height: iconSize.height)
                                        .foregroundStyle(Color.primary)
                                    
                                }
                                
                            }
                        }
                        .clipShape(Circle())
                        .contentShape(Circle())
                }
                
            } else {
                
                Circle()
                    .skeleton(
                        enabled: isLoadingImage,
                        type: .circle,
                        frameColor: .DesignSystem.skeletonBackground,
                        cornerRadius: 100
                    )
                    .foregroundStyle(Color.DesignSystem.buttonBackground)
                    .frame(width: circleSize.width, height: circleSize.height)
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
                                    .frame(width: iconSize.width, height: iconSize.height)
                                    .foregroundStyle(Color.primary)
                                
                            }
                            
                        }
                    }
                    .clipShape(Circle())
                    .contentShape(Circle())
                
            }
            
            Text(text)
                .font(.DesignSystem.subtitle1(weight: .bold))
                .foregroundStyle(Color.primary)
            
        }
        .onAppear(perform: onAppear)
        .onChange(of: pictureUrl) { oldValue, newValue in
            loadImage()
        }
    }
    
    // MARK: Privates
    
    private func onAppear() -> Void {
        loadImage()
    }
    
    private func loadImage() -> Void {
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
    ProfilePictureLarge(pictureUrl: User.randomUser().profilePictureUrlString, text: User.randomUser().firstName, action: nil)
}
