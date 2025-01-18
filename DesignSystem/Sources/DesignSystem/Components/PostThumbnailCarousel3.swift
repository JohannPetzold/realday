//
//  PostThumbnailCarousel3.swift
//  DesignSystem
//
//  Created by Johann Petzold on 18/01/2025.
//

import SwiftUI
import Models

// MARK: - Post Thumbnail Carousel 3

public struct PostThumbnailCarousel3: View {
    
    // MARK: Properties
    
    private let posts: [Post]
    private let showDate: Bool
    private let tapAction: ((Post) -> Void)?
    
    // MARK: States
    
    @State private var scrollOffset: CGFloat = 0
    @State private var carouselHeight: CGFloat = 0
    @State private var currentIndex: Int = 0
    
    // MARK: Constants
    
    private let layoutSize: CGSize = .init(width: 240, height: 388)
    private let sizeReducer: CGFloat = 0.9
    private let hSpacing: CGFloat = .DesignSystem.Spacing.l
    // MARK: Init
    
    public init(posts: [Post], showDate: Bool = false, tapAction: ((Post) -> Void)?) {
        self.posts = posts
        self.showDate = showDate
        self.tapAction = tapAction
    }
    
    // MARK: Layout
    
    public var body: some View {
        VStack(spacing: .DesignSystem.Spacing.m) {
            
            ScrollViewReader { scrollProxy in
                
                ScrollView(.horizontal) {
                    
                    LazyHStack(spacing: hSpacing) {
                        
                        ForEach(0..<posts.count, id: \.self) { i in
                            
                            PostThumbnail(post: posts[i]) {
                                onTapPost(posts[i])
                            }
                            .thumbnailFrame(index: i, actualIndex: currentIndex, size: layoutSize, reduceMultiplier: 1)
                            .id(i)
                            
                        }
                        
                    }
                    .padding(.horizontal, (UIScreen.main.bounds.size.width / 2) - (thumbnailWidth() / 2))
                    .fixedSize(horizontal: false, vertical: true)
                    .scrollRecorder { value in
                        scrollOffset = -value
                        updateActualIndex()
                    }
                    .heightRecorder { value in
                        carouselHeight = value
                    }
                    .onAppear {
                        scrollProxy.scrollTo(posts.count - 1, anchor: .center)
                        currentIndex = posts.count - 1
                    }
                    
                }
                .scrollIndicators(.never)
                
            }
            
            VStack(spacing: .DesignSystem.Spacing.xs) {
                
                if showDate {
                 
                    Text(dateText(index: currentIndex))
                        .font(.DesignSystem.body1(weight: .bold))
                        .foregroundStyle(.primary)
                    
                } else {
                    
                    Text(hourText(index: currentIndex))
                        .font(.DesignSystem.body1(weight: .bold))
                        .foregroundStyle(.primary)
                    
                }
                
                Text(captionText(index: currentIndex))
                    .font(.DesignSystem.sub1(weight: .medium))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, .DesignSystem.Spacing.l)
                    .frame(height: 64, alignment: .top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            
        }
    }
    
    // MARK: Privates
    
    private func thumbnailWidth(sizeReducer: CGFloat = 1) -> CGFloat {
        return carouselHeight * (240/388) * sizeReducer
    }
    
    private func updateActualIndex() -> Void {
        let thumbnailWidth = thumbnailWidth()
        let startScreenLimit = (thumbnailWidth / 2) + (hSpacing / 2)
        
        if posts.count == 1 {
            currentIndex = 0
        } else {
            for i in 0..<posts.count {
                if i == 0 && scrollOffset < startScreenLimit {
                    currentIndex = i
                } else if i == posts.count - 1 && posts.count > 2 && scrollOffset > startScreenLimit + ((thumbnailWidth + hSpacing) * CGFloat(posts.count - 2)) {
                    currentIndex = posts.count - 1
                } else if scrollOffset > startScreenLimit + ((thumbnailWidth + hSpacing) * CGFloat(i)) && scrollOffset < startScreenLimit + ((thumbnailWidth + hSpacing) * CGFloat(i + 1)) {
                    currentIndex = min(posts.count - 1, i + 1)
                }
            }
        }
    }
    
    // MARK: Privates
    
    private func dateText(index: Int) -> String {
        if index < posts.count {
            return posts[index].created.formatRelativeDayAndTime()
        }
        return ""
    }
    
    private func hourText(index: Int) -> String {
        if index < posts.count {
            return posts[index].created.formatTimeOnly()
        }
        return ""
    }
    
    private func captionText(index: Int) -> String {
        if index < posts.count {
            return posts[index].text ?? ""
        }
        return ""
    }
    
    // MARK: Actions
    
    private func onTapPost(_ post: Post) -> Void {
        if let tapAction {
            tapAction(post)
        }
    }
}

fileprivate extension View {
    
    @ViewBuilder func thumbnailFrame(index: Int, actualIndex: Int, size: CGSize, reduceMultiplier: CGFloat) -> some View {
        if size.width > 0 && size.height > 0 {
            self
                .frame(width: size.width * (actualIndex == index ? 1 : reduceMultiplier), height: size.height * (actualIndex == index ? 1 : reduceMultiplier))
        } else {
            self
        }
    }
    
    @ViewBuilder func scrollRecorder(update: @escaping (_ value: CGFloat) -> Void) -> some View {
        self
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(key: ScrollPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minX)
                }
            )
            .onPreferenceChange(ScrollPreferenceKey.self, perform: update)
    }
}

// MARK: - Preferences Keys

fileprivate struct ScrollPreferenceKey: @preconcurrency PreferenceKey {
    
    @MainActor static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    }
}

// MARK: - Previews

#Preview {
    PostThumbnailCarousel3(posts: posts.sorted(by: { $0.created > $1.created }), tapAction: nil)
}

fileprivate let posts: [Post] = {
    var posts: [Post] = []
    posts.append(.randomPost())
    posts.append(.randomPost())
    posts.append(.randomPost())
    return posts
}()
