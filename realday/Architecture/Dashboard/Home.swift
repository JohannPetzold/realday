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
    @StateObject var model: HomeViewModel = .shared
    
    @State private var navHeight: CGFloat = 0
    @State private var isProfilePresented: Bool = false
    @State private var presentedUser: User?
    @State private var isPostPresented: Bool = false
    @State private var presentedPost: Post = .randomPost()
    
    // MARK: Layout
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                ScrollView(.vertical) {
                    
                    LazyVStack(spacing: .DesignSystem.Spacing.l) {
                        
                        ForEach(model.dayUsers, id: \.self) { user in
                            
                            VStack(spacing: .DesignSystem.Spacing.l) {
                                
                                ProfilePictureSmall(user: user) {
                                    onTapUser(user)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, .DesignSystem.Spacing.l)
                                
                                PostThumbnailCarousel2(
                                    posts: user.posts!.filter({ $0.created > Date().addingTimeInterval(-86400) }).sorted(by: { $0.created > $1.created }),
                                    showDate: true,
                                    tapAction: onTapPost
                                )
                                
                            }
                            
                        }
                        
                    }
                    .padding(.top, navHeight + .DesignSystem.Spacing.l)
                    
                }
                .scrollIndicators(.hidden)
                
                HStack(spacing: 0) {
                    
                    Spacer()
                    
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
                    BlurEffect(style: .systemUltraThinMaterial)
                        .ignoresSafeArea(.all)
                )
                .heightRecorder { value in
                    navHeight = value
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
            }
            .navigationDestination(isPresented: $isProfilePresented) {
                UserProfile(isPresented: $isProfilePresented, user: presentedUser)
            }
            .navigationDestination(isPresented: $isPostPresented) {
                PostView(isPresented: $isPostPresented, post: presentedPost)
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
        presentedPost = post
        isPostPresented = true
    }
    
    private func onTapProfile() -> Void {
        guard let user = userManager.user else { return }
        presentedUser = user
        isProfilePresented = true
    }
}

// MARK: Previews

#Preview {
    Home()
}
