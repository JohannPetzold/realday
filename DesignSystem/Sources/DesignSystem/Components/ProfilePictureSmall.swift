//
//  ProfilePictureSmall.swift
//  DesignSystem
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI
import Models

// MARK: - Profile Picture Small

public struct ProfilePictureSmall: View {
    
    // MARK: Properties
    
    private let user: User
    private let action: (() -> Void)?
    
    // MARK: States
    
    @State private var image: Image? = nil
    @State private var uiImage: UIImage? = nil
    @State private var isLoadingImage: Bool = false
    @State private var errorLoadingImage: Bool = false
    
    // MARK: Constants
    
    private let imageSize: CGSize = .init(width: 20, height: 20)
    
    // MARK: Init
    
    public init(user: User, action: (() -> Void)?) {
        self.user = user
        self.action = action
    }
    
    // MARK: Layout
    
    public var body: some View {
        HStack(spacing: .DesignSystem.Spacing.s) {
            
            if isLoadingImage {
                
                Circle()
                    .skeleton(
                        enabled: true,
                        type: .circle,
                        frameColor: .DesignSystem.skeletonBackground,
                        cornerRadius: 100
                    )
                    .frame(width: imageSize.width, height: imageSize.height)
                
            } else if let image {
                
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize.width, height: imageSize.height)
                    .clipShape(Circle())
                
            } else {
                
                ZStack {
                 
                    Circle()
                        .foregroundStyle(Color.DesignSystem.skeletonBackground)
                    
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 8, height: 8)
                        .foregroundStyle(.primary)
                    
                }
                .frame(width: imageSize.width, height: imageSize.height)
                .clipShape(Circle())
                
            }
            
            Text("\(user.firstName) \(user.lastName)")
                .font(.DesignSystem.sub1(weight: .bold))
                .foregroundStyle(.primary)
                .lineLimit(1)
            
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
        .onAppear(perform: onAppear)
    }
    
    // MARK: Privates
    
    private func onAppear() -> Void {
        self.isLoadingImage = true
        Task.detached {
            if let pictureUrl = user.profilePictureUrlString, let uiImage = await NSCacheManager.shared.getImage(name: pictureUrl) {
                let image = Image(uiImage: uiImage)
                await MainActor.run {
                    self.uiImage = uiImage
                    self.image = image
                    self.isLoadingImage = false
                }
            } else if let pictureUrl = user.profilePictureUrlString, let localUrl = await FileStorageManager.getFileFromTmp(filename: pictureUrl), let imageData = try? Data(contentsOf: localUrl), let uiImage = UIImage(data: imageData) {
                await NSCacheManager.shared.add(image: uiImage, name: pictureUrl)
                let image = Image(uiImage: uiImage)
                await MainActor.run {
                    self.uiImage = uiImage
                    self.image = image
                    self.isLoadingImage = false
                }
            } else if let pictureUrl = user.profilePictureUrlString, let imageUrl = Bundle.module.url(forResource: pictureUrl, withExtension: "jpg"), let imageData = try? Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
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
        
        ForEach(0..<6, id: \.self) { _ in
            
            ProfilePictureSmall(user: .randomUser(), action: nil)
            
        }
    }
}
