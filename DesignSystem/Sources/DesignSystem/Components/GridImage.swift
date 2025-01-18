//
//  GridImage.swift
//  DesignSystem
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI
import Models

// MARK: - Grid Image

public struct GridImage: View {
    
    // MARK: Properties
    
    private let pictureUrl: String
    private let date: Date
    
    // MARK: States
    
    @State private var image: Image? = nil
    @State private var isLoadingImage: Bool = false
    @State private var errorLoadingImage: Bool = false
    
    // MARK: Init
    
    public init(pictureUrl: String, date: Date) {
        self.pictureUrl = pictureUrl
        self.date = date
    }
    
    // MARK: Layout
    
    public var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(image == nil ? Color.DesignSystem.skeletonBackground : .clear)
                
            if image == nil && !isLoadingImage {
                
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.primary)
                
            }
            
            Text(date.formatTimeOnly())
                .font(.DesignSystem.sub1(weight: .bold))
                .foregroundStyle(image == nil ? Color.primary : Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.leading, .DesignSystem.Spacing.xs)
                .padding(.bottom, .DesignSystem.Spacing.xs)
            
        }
        .background(
            ZStack {
                if let image {
                    
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                    
                    BlurGradient(height: 24)
                    
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .aspectRatio(.init(width: 240, height: 420), contentMode: .fit)
        .onAppear(perform: onAppear)
    }
    
    // MARK: Privates
    
    private func onAppear() -> Void {
        loadImage()
    }
    
    private func loadImage() -> Void {
        self.isLoadingImage = true
        Task.detached {
            if let uiImage = await NSCacheManager.shared.getImage(name: pictureUrl) {
                let image = Image(uiImage: uiImage)
                await MainActor.run {
                    self.image = image
                    self.isLoadingImage = false
                }
            } else if let localUrl = await FileStorageManager.getFileFromTmp(filename: pictureUrl), let imageData = try? Data(contentsOf: localUrl), let uiImage = UIImage(data: imageData) {
                await NSCacheManager.shared.add(image: uiImage, name: pictureUrl)
                let image = Image(uiImage: uiImage)
                await MainActor.run {
                    self.image = image
                    self.isLoadingImage = false
                }
            } else if let imageUrl = Bundle.module.url(forResource: pictureUrl, withExtension: "jpg"), let imageData = try? Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
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
}

// MARK: - Previews

#Preview {
    GridImage(pictureUrl: Post.randomPost().pictureUrl, date: Date())
}
