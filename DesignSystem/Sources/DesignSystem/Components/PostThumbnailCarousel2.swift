//
//  PostThumbnailCarousel2.swift
//  DesignSystem
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI
import Models

public struct PostThumbnailCarousel2: View {
    
    // MARK: Properties
    
    private let posts: [Post]
    private let showDate: Bool
    private let tapAction: ((Post) -> Void)?

    // MARK: States
    
    @GestureState private var dragState = DragState.inactive
    @State private var carouselLocation = 0
    
    @State var widthFrame: CGFloat = 0
    @State var thumbnailsSize: [CGSize] = []
    @State var thumbnailsAppears: [Bool] = []
    
    // MARK: Enum
    
    enum DragState {
        case inactive
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .inactive:
                return false
            case .dragging:
                return true
            }
        }
    }
    
    // MARK: Constants
    
    private let layoutSize: CGSize = CGSize(width: 240, height: 388)
    private let dragThreshold: CGFloat = 100
    private var sizeReducer: CGFloat = 0.9
    
    // MARK: Init
    
    public init(posts: [Post], showDate: Bool = false, tapAction: ((Post) -> Void)?) {
        self.posts = posts
        self.showDate = showDate
        self.tapAction = tapAction
    }
        
    // MARK: Layout
    
    public var body: some View {
        VStack(spacing: .DesignSystem.Spacing.m) {
            
            ZStack {
                
                ForEach(0..<posts.count, id:\.self) { i in
                    
                    ZStack {
                        
                        PostThumbnail(post: posts[i]) {
                            onTapPost(posts[i])
                        }
                        .thumbnailFrame(index: i, actualIndex: carouselLocation, size: layoutSize, reduceMultiplier: sizeReducer)
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
                        .animation(.easeOut(duration: 0.2), value: dragState.translation)
                        .offset(x: computeOffsetWidth(i), y: 0)
                    }
                    
                }
                
            }
            .gesture(
                DragGesture()
                    .updating($dragState) { drag, state, transaction in
                        state = .dragging(translation: drag.translation)
                    }
                    .onEnded(onDragEnded)
            )
            
            VStack(spacing: .DesignSystem.Spacing.xs) {
                
                if showDate {
                 
                    Text("\(posts[carouselLocation].created.formatRelativeDayAndTime())")
                        .font(.DesignSystem.body1(weight: .bold))
                        .foregroundStyle(.primary)
                    
                } else {
                    
                    Text("\(posts[carouselLocation].created.formatTimeOnly())")
                        .font(.DesignSystem.body1(weight: .bold))
                        .foregroundStyle(.primary)
                    
                }
                
                Text(posts[carouselLocation].text ?? "")
                    .font(.DesignSystem.sub1(weight: .medium))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, .DesignSystem.Spacing.l)
                    .frame(height: 64, alignment: .top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentTransition(.opacity)
                    .animation(.easeOut(duration: 0.2), value: carouselLocation)
                
            }
            
        }
    }
    
    // MARK: Privates
    
    /// Called when drag end, change carouselLocation depending on drag location
    /// - Parameter drag: drag value from the @GestureState
    private func onDragEnded(drag: DragGesture.Value) {
//        if (drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold) && carouselLocation > 0 {
//            carouselLocation = carouselLocation - 1
//        } else if (drag.predictedEndTranslation.width < -dragThreshold || drag.translation.width < -dragThreshold) && carouselLocation < posts.count - 1 {
//            carouselLocation = carouselLocation + 1
//        }
        if (drag.predictedEndTranslation.width < -dragThreshold || drag.translation.width < -dragThreshold) && carouselLocation > 0 {
            carouselLocation = carouselLocation - 1
        } else if (drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold) && carouselLocation < posts.count - 1 {
            carouselLocation = carouselLocation + 1
        }
    }
    
    // MARK: Offset
    
    /// Get offset width for array's element
    /// - Parameters:
    ///   - i: array's element index
    ///   - parentWidth: width of the carousel
    /// - Returns: initial offset position + drag offset
    private func computeOffsetWidth(_ i: Int) -> CGFloat {
        guard i < thumbnailsSize.count else { return 0 }
        guard carouselLocation < thumbnailsSize.count else { return 0 }
        let itemWidth: CGFloat = thumbnailsSize[i].width
        let parentWidth: CGFloat = thumbnailsSize[carouselLocation].width
        let initialOffset: CGFloat = parentWidth / 2 - itemWidth / 2
        let dragOffset: CGFloat = getOffset(i, itemWidth: itemWidth, parentWidth: parentWidth)
        
        return initialOffset + dragOffset
    }
    
    /// Get drag offset width
    /// - Parameters:
    ///   - i: index of the element
    ///   - itemWidth: width of the item
    ///   - parentWidth: width of the carousel
    /// - Returns: drag offset width depending of element's place
    private func getOffset(_ i: Int, itemWidth: CGFloat, parentWidth: CGFloat) -> CGFloat {
//        if (i) == carouselLocation {
//            return self.dragState.translation.width
//        }
//        else if i < carouselLocation {
//            return self.dragState.translation.width - (CGFloat(abs(carouselLocation - i)) * ((parentWidth / 2) + (itemWidth / 2) + ((parentWidth - itemWidth) / 2) + 15))
//        } else if i > carouselLocation {
//            return self.dragState.translation.width + (CGFloat(abs(carouselLocation - i)) * ((parentWidth / 2) + (itemWidth / 2) - ((parentWidth - itemWidth) / 2) + 15))
//        } else {
//            return 1000
//        }
        if i == carouselLocation {
            return self.dragState.translation.width
        } else if i > carouselLocation {
            return self.dragState.translation.width - (CGFloat(abs(carouselLocation - i)) * ((parentWidth / 2) + (itemWidth / 2) + ((parentWidth - itemWidth) / 2) + 15))
        } else if i < carouselLocation {
            return self.dragState.translation.width + (CGFloat(abs(carouselLocation - i)) * ((parentWidth / 2) + (itemWidth / 2) - ((parentWidth - itemWidth) / 2) + 15))
        } else {
            return 1000
        }
    }
    
    // MARK: Actions
    
    private func onTapPost(_ post: Post) -> Void {
        if let tapAction {
            tapAction(post)
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

fileprivate struct ThumbnailPreferenceKey: @preconcurrency PreferenceKey {
    
    @MainActor static var defaultValue: CGSize = .init(width: 0, height: 0)
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    }
}

#Preview {
    PostThumbnailCarousel2(posts: posts.sorted(by: { $0.created > $1.created }), tapAction: nil)
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
