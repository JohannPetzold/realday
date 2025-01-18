//
//  Home.swift
//  realday
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI
import DesignSystem
import Models

// MARK: - Home

struct Home: View {
    
    // MARK: States
    
    @StateObject var userManager: UserManager = .shared
    @StateObject var appManager: AppManager = .shared
    @StateObject var model: HomeViewModel = HomeViewModel()
    
    @State private var navHeight: CGFloat = 0
    @State private var bottomButtonHeight: CGFloat = 0
    @State private var isProfilePresented: Bool = false
    @State private var presentedUser: User?
    @State private var isPostPresented: Bool = false
    @State private var presentedPost: Post = .randomPost()
    @State private var isNewPostPresented: Bool = false
    @State private var isSearchPresented: Bool = false
    
    // MARK: Constants
    
    let columns = [
        GridItem(.adaptive(minimum: 60, maximum: 140), spacing: .DesignSystem.Spacing.s),
        GridItem(.adaptive(minimum: 60, maximum: 140), spacing: .DesignSystem.Spacing.s),
        GridItem(.adaptive(minimum: 60, maximum: 140), spacing: .DesignSystem.Spacing.s)
    ]
    
    // MARK: Layout
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                if model.displayType == .carousel {
                
                    if model.dayUsers.isEmpty {
                        
                        TextPlaceholder(
                            title: "No user yet",
                            subtitle: "Search for users to follow",
                            buttonTitle: nil,
                            action: nil
                        )
                        
                    } else {
                        
                        ScrollView(.vertical) {
                            
                            LazyVStack(spacing: .DesignSystem.Spacing.l) {
                                
                                ForEach(model.dayUsers, id: \.self) { user in
                                    
                                    VStack(spacing: .DesignSystem.Spacing.l) {
                                        
                                        ProfilePictureSmall(user: user) {
                                            onTapUser(user)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, .DesignSystem.Spacing.l)
                                        
                                        PostThumbnailCarousel3(
                                            posts: user.posts!.filter({ $0.created > Date().addingTimeInterval(-86400) }).sorted(by: { $0.created < $1.created }),
                                            showDate: true,
                                            tapAction: onTapPost
                                        )
                                        
                                    }
                                    
                                }
                                
                            }
                            .padding(.top, navHeight + .DesignSystem.Spacing.l)
                            .padding(.bottom, bottomButtonHeight + .DesignSystem.Spacing.l)
                            
                        }
                        .scrollIndicators(.hidden)
                        
                    }
                    
                } else {
                    
                    if model.gridPosts.isEmpty {
                        
                        TextPlaceholder(
                            title: "No user yet",
                            subtitle: "Search for users to follow",
                            buttonTitle: nil,
                            action: nil
                        )
                        
                    } else {
                        
                        ScrollView(.vertical) {
                            
                            LazyVStack(spacing: .DesignSystem.Spacing.l) {
                                
                                ForEach(model.sortedTimePeriods(), id: \.self) { period in
                                    
                                    if let posts = model.gridPosts[period], !posts.isEmpty {
                                        
                                        VStack(alignment: .leading, spacing: .DesignSystem.Spacing.m) {
                                            
                                            Text(period.rawValue)
                                                .font(.DesignSystem.subtitle1(weight: .bold))
                                                .padding(.horizontal, .DesignSystem.Spacing.l)
                                            
                                            LazyVGrid(
                                                columns: columns, spacing: .DesignSystem.Spacing.s) {
                                                    ForEach(posts) { post in
                                                        GridImage(pictureUrl: post.pictureUrl, date: post.created)
                                                    }
                                                }
                                            .padding(.horizontal, .DesignSystem.Spacing.l)
                                        }
                                    }
                                }
                                
                            }
                            .padding(.top, navHeight + .DesignSystem.Spacing.l)
                            .padding(.bottom, bottomButtonHeight + .DesignSystem.Spacing.l)
                            
                        }
                        .scrollIndicators(.hidden)
                        
                    }
                    
                }
                
                
                HStack(spacing: .DesignSystem.Spacing.xl) {
                    
                    MenuPicker(buttons: [
                        .init(text: "Carousel", image: "rectangle.split.3x1.fill", action: onTapMenuCarousel),
                        .init(text: "Grid", image: "rectangle.grid.2x2.fill", action: onTapMenuGrid)
                    ]) {
                        HStack(spacing: .DesignSystem.Spacing.s) {
                            
                            Label("Past 24h", systemImage: model.displayType == .carousel ? "rectangle.split.3x1.fill" : "rectangle.grid.2x2.fill")
                            
                            Image(systemName: "chevron.down")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 12, height: 8)
                        }
                        .font(.DesignSystem.subtitle1(weight: .bold))
                        .foregroundStyle(Color.primary)
                        
                    }
                    
                    Spacer()
                    
                    ImageButton(
                        image: Image(systemName: "magnifyingglass"),
                        color: Color.primary,
                        contentMode: .fit,
                        size: .init(width: 28, height: 28),
                        action: onTapSearch
                    )
                    
//                    ImageButton(
//                        image: Image(systemName: "camera"),
//                        color: Color.primary,
//                        contentMode: .fit,
//                        size: .init(width: 32, height: 32),
//                        action: onTapCamera
//                    )
                    
                    ProfileButton(
                        pictureUrl: userManager.user?.profilePictureUrlString,
                        action: onTapProfile
                    )
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.top, .DesignSystem.Spacing.s)
                .padding(.bottom, .DesignSystem.Spacing.m)
                .padding(.horizontal, .DesignSystem.Spacing.l)
                .background(
                    BlurEffect(style: .regular)
                        .ignoresSafeArea(.all)
                )
                .heightRecorder { value in
                    navHeight = value
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                Button(action: onTapCamera) {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(Color.white)
                        .frame(width: 64, height: 64)
                        .background(
                            Color.blue
                        )
                        .clipShape(Circle())
                        .contentShape(Circle())
                }
                .heightRecorder { value in
                    bottomButtonHeight = value
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, .DesignSystem.Spacing.m)
                
            }
            .navigationDestination(isPresented: $isProfilePresented) {
                UserProfile(isPresented: $isProfilePresented, user: presentedUser)
            }
            .navigationDestination(isPresented: $isPostPresented) {
                PostView(isPresented: $isPostPresented, post: presentedPost)
            }
            .fullScreenCover(isPresented: $isNewPostPresented) {
                NewPost(isPresented: $isNewPostPresented)
            }
            .fullScreenCover(isPresented: $isSearchPresented) {
                Search(isPresented: $isSearchPresented)
            }
        }
    }
    
    // MARK: Privates
    
    // MARK: Actions
    
    private func onTapUser(_ user: User) -> Void {
        presentedUser = user
        isProfilePresented = true
    }
    
    private func onTapPost(_ post: Post) -> Void {
//        presentedPost = post
//        isPostPresented = true
    }
    
    private func onTapProfile() -> Void {
        guard let user = userManager.user else { return }
        presentedUser = user
        isProfilePresented = true
    }
    
    private func onTapCamera() -> Void {
        isNewPostPresented = true
    }
    
    private func onTapSearch() -> Void {
        isSearchPresented = true
    }
    
    private func onTapMenuCarousel() -> Void {
        model.displayType = .carousel
    }
    
    private func onTapMenuGrid() -> Void {
        model.displayType = .grid
    }
}

// MARK: Previews

#Preview {
    Home()
}
