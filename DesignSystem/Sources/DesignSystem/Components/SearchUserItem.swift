//
//  SearchUserItem.swift
//  DesignSystem
//
//  Created by Johann Petzold on 18/01/2025.
//

import SwiftUI
import Models

// MARK: - Search User Item

public struct SearchUserItem: View {
    
    // MARK: Properties
    
    private let user: User
    private let isFollowed: Bool
    private let action: ((User) -> Void)?
    private let followAction: ((User) -> Void)?
    
    // MARK: States
    
    @State private var image: Image? = nil
    @State private var uiImage: UIImage? = nil
    @State private var isLoadingImage: Bool = false
    @State private var errorLoadingImage: Bool = false
    
    // MARK: Constants
    
    private let imageSize: CGSize = .init(width: 48, height: 48)
    
    // MARK: Init
    
    public init(user: User, isFollowed: Bool, action: ((User) -> Void)?, followAction: ((User)-> Void)?) {
        self.user = user
        self.isFollowed = isFollowed
        self.action = action
        self.followAction = followAction
    }
    
    // MARK: Layout
    
    public var body: some View {
        HStack(spacing: .DesignSystem.Spacing.l) {
            
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
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.primary)
                    
                }
                .frame(width: imageSize.width, height: imageSize.height)
                .clipShape(Circle())
                
            }
            
            Text("\(user.firstName) \(user.lastName)")
                .font(.DesignSystem.body1(weight: .bold))
                .foregroundStyle(.primary)
                .lineLimit(1)
            
            Spacer()
            
            Button(action: onTapFollow) {
                Text(followButtonTitle())
                    .font(.DesignSystem.body2(weight: .bold))
                    .foregroundStyle(followButtonTextColor())
                    .padding(.horizontal, .DesignSystem.Spacing.l)
                    .padding(.vertical, .DesignSystem.Spacing.s)
                    .background(
                        followButtonBackgroundColor()
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .contentShape(RoundedRectangle(cornerRadius: 8))
            }
            
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
            } else if let pictureUrl = user.profilePictureUrlString, let localUrl = await FileStorageManager.getFileFromDocuments(filename: pictureUrl), let imageData = try? Data(contentsOf: localUrl), let uiImage = UIImage(data: imageData) {
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
                     
    private func followButtonTitle() -> String {
        if isFollowed {
            return "Unfollow"
        }
        return "Follow"
    }
    
    private func followButtonTextColor() -> Color {
        if isFollowed {
            return Color.primary
        }
        return Color.white
    }
    
    private func followButtonBackgroundColor() -> Color {
        if isFollowed {
            return Color.secondary.opacity(0.4)
        }
        return Color.blue
    }
    
    // MARK: Actions
    
    private func onTap() -> Void {
        if let action {
            action(user)
        }
    }
    
    private func onTapFollow() -> Void {
        if let followAction {
            followAction(user)
        }
    }
}

// MARK: - Previews

#Preview {
    VStack(spacing: .DesignSystem.Spacing.s) {
        
        SearchUserItem(user: .randomUser(), isFollowed: false, action: nil, followAction: nil)
        
        SearchUserItem(user: .randomUser(), isFollowed: true, action: nil, followAction: nil)
        
    }
    .padding(.horizontal, .DesignSystem.Spacing.l)
}
