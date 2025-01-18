//
//  PostThumbnailCarousel.swift
//  DesignSystem
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI
import Models
import Combine

// MARK: - Post Thumbnail Carousel

public struct PostThumbnailCarousel: View {
    
    // MARK: Properties
    
    private let posts: [Post]
    private let tapAction: ((String) -> Void)?
    
    // MARK: States
    
    @State private var scrollOffset: CGFloat = 0
    @State private var widthFrame: CGFloat = 0
    @State private var thumbnailsSize: [CGSize] = []
    @State private var actualThumbnail: Int = 0
    @State private var sizeReducer: CGFloat = 0.9
    @State private var thumbnailsAppears: [Bool] = []
    
    // MARK: Publisher
    
    let detector: CurrentValueSubject<CGFloat, Never>
    let publisher: AnyPublisher<CGFloat, Never>
    
    // MARK: Constants
    
    private let hSpacing: CGFloat = 16
    private let layoutSize: CGSize = .init(width: 240, height: 388)
    
    // MARK: Init
    
    public init(posts: [Post], tapAction: ((String) -> Void)?) {
        self.posts = posts
        self.tapAction = tapAction
        
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        self.publisher = detector
            .debounce(for: .seconds(0.05), scheduler: DispatchQueue.main)
            .dropFirst()
            .eraseToAnyPublisher()
        self.detector = detector
    }
    
    // MARK: Layout
    
    public var body: some View {
        VStack(spacing: .DesignSystem.Spacing.m) {
            
            ScrollViewReader { scrollProxy in
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: hSpacing) {
                        
                        ForEach(0..<posts.count, id:\.self) { i in
                            
                            PostThumbnail(post: posts[i]) {
                                onTapPost(posts[i].id)
                            }
                            .thumbnailFrame(index: i, actualIndex: actualThumbnail, size: layoutSize, reduceMultiplier: sizeReducer)
                            .thumbnailSizeRecorder { value in
                                if thumbnailsSize.isEmpty {
                                    thumbnailsSize = Array(repeating: CGSize(width: 0, height: 0), count: posts.count)
                                }
                                if thumbnailsSize.count > i {
                                    thumbnailsSize[i] = value
                                } else {
                                    thumbnailsSize.append(contentsOf: Array(repeating: CGSize(width: 0, height: 0), count: i - (thumbnailsSize.count - 1)))
                                    thumbnailsSize[i] = value
                                }
                                
                            }
                            .animation(.easeOut(duration: 0.2), value: scrollOffset)
                            .id(i)
                            .onAppear {
                                thumbnailsAppears.append(true)
                                scrollProxy.scrollTo(posts.count - 1, anchor: .center)
                                actualThumbnail = posts.count - 1
                            }
                            
                        }
                        
                    }
                    .scrollRecorder { value in
                        scrollOffset = -value + leadingPadding()
                        detector.send(scrollOffset)
                        updateActual()
                    }
                    .widthRecorder { value in
                        widthFrame = value - UIScreen.main.bounds.size.width + leadingPadding() + trailingPadding()
                    }
                    .onChange(of: posts, { oldValue, newValue in
                        if actualThumbnail > newValue.count - 1 {
                            actualThumbnail = newValue.count - 1
                        }
                    })
                    .padding(.leading, leadingPadding() + extraLeadingPadding())
                    .padding(.trailing, trailingPadding())
                    
                }
                
            }
            
            VStack(spacing: .DesignSystem.Spacing.xs) {
                
                Text("\(posts[actualThumbnail].created.formatDayMonthHourMinute())")
                    .font(.DesignSystem.body2(weight: .bold))
                    .foregroundStyle(.primary)
                
                Text(posts[actualThumbnail].text ?? "")
                    .font(.DesignSystem.sub1(weight: .medium))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, .DesignSystem.Spacing.l)
                    .frame(height: 64, alignment: .top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentTransition(.opacity)
                    .animation(.easeOut(duration: 0.2), value: actualThumbnail)
                
            }
            
        }
    }
    
    // MARK: Privates
    
    private func updateActual() -> Void {
        var arrayWidth: CGFloat = 0
        var triggerMax: CGFloat = 0
        var triggerMin: CGFloat = 0
        for i in 0..<thumbnailsSize.count {
            if actualThumbnail == i {
                triggerMax = arrayWidth + ((thumbnailsSize[i].width / 2) + (hSpacing / 2))
                if i > 0 {
                    triggerMax += ((layoutSize.width - thumbnailsSize[i-1].width) / 2)
                    triggerMin = arrayWidth - ((thumbnailsSize[i].width / 2) + (hSpacing / 2)) + ((layoutSize.width - thumbnailsSize[i-1].width) / 2)
                }
                if scrollOffset < triggerMin && i > 0 {
                    actualThumbnail = i - 1
                    break
                } else if scrollOffset >= triggerMax && i < thumbnailsSize.count - 1 {
                    actualThumbnail = i + 1
                    break
                } else {
                    break
                }
            }
            arrayWidth += thumbnailsSize[i].width + hSpacing
        }
    }
    
    /// Leading padding.
    private func leadingPadding() -> CGFloat {
        if let width = thumbnailsSize.last?.width {
            return (UIScreen.main.bounds.size.width / 2) - (width / 2) - .DesignSystem.Spacing.l
        }
        return (UIScreen.main.bounds.size.width / 2) - .DesignSystem.Spacing.l
    }
    
    /// Extra leading padding for on drag end.
    private func extraLeadingPadding() -> CGFloat {
        let extra = (layoutSize.width - (layoutSize.width * sizeReducer)) / 2
        return actualThumbnail > 0 ? -extra : 0
    }
    
    /// Trailing padding.
    private func trailingPadding() -> CGFloat {
        if let width = thumbnailsSize.last?.width {
            return (UIScreen.main.bounds.size.width / 2) - (width / 2)
        }
        return (UIScreen.main.bounds.size.width / 2)
    }
    
    /// Thumbnail width.
    /// - Parameter index: Item index.
    private func thumbnailWidth(index: Int) -> CGFloat {
        if thumbnailsSize.count > index {
            let width = thumbnailsSize[index].width
            return actualThumbnail == index ? width : width * sizeReducer
        }
        return 0
    }
    
    /// Thumbnail height.
    /// - Parameter index: Item index.
    private func thumbnailHeight(index: Int) -> CGFloat {
        if thumbnailsSize.count > index {
            let height = thumbnailsSize[index].height
            return actualThumbnail == index ? height : height * sizeReducer
        }
        return 0
    }
    
    
    // MARK: Actions
    
    private func onTapPost(_ id: String) -> Void {
        if let tapAction {
            tapAction(id)
        }
    }
}

// MARK: - Recorders

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
    
    @ViewBuilder func widthRecorder(update: @escaping (_ value: CGFloat) -> Void) -> some View {
        self
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(key: WidthPreferenceKey.self, value: proxy.size.width)
                }
            )
            .onPreferenceChange(WidthPreferenceKey.self, perform: update)
    }
    
    @ViewBuilder func thumbnailSizeRecorder(update: @escaping (_ value: CGSize) -> Void) -> some View {
        self
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(key: ThumbnailPreferenceKey.self, value: proxy.size)
                }
            )
            .onPreferenceChange(ThumbnailPreferenceKey.self, perform: update)
    }
}

// MARK: - Preferences Keys

fileprivate struct ScrollPreferenceKey: @preconcurrency PreferenceKey {
    
    @MainActor static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    }
}

@MainActor
fileprivate struct WidthPreferenceKey: @preconcurrency PreferenceKey {
    
    @MainActor  static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    }
}

@MainActor
fileprivate struct ThumbnailPreferenceKey: @preconcurrency PreferenceKey {
    
    @MainActor  static var defaultValue: CGSize = .init(width: 0, height: 0)
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    }
}

// MARK: - Previews

#Preview {
    PostThumbnailCarousel(posts: posts, tapAction: nil)
}

fileprivate let posts: [Post] = {
    var posts: [Post] = []
    posts.append(.randomPost())
    posts.append(.randomPost())
    posts.append(.randomPost())
    posts.append(.randomPost())
    posts.append(.randomPost())
    posts.append(.randomPost())
    return posts
}()
