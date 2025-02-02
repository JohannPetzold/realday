//
//  UserProfile.swift
//  realday
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI
import Models
import DesignSystem
import PhotosUI

// MARK: - User Profile

struct UserProfile: View {
    
    // MARK: Properties
    
    @Binding var isPresented: Bool
    let user: User?
    
    // MARK: States
    
    @StateObject var userManager: UserManager = .shared
    @StateObject var model: UserProfileViewModel = UserProfileViewModel()
    @State private var navBarHeight: CGFloat = 0
    @State private var presentCamera: Bool = false
    @State private var errorCamera: Bool = false
    @State private var timerErrorCamera: Double = 0
    @State private var updateProfilePicture: Bool = false
    
    // MARK: Constants
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    // MARK: Layout
    
    var body: some View {
        ZStack {
            
            if !model.isLoadingDatas {
                
                if let user {
                    
                    if !model.filteredPosts.isEmpty {
                        
                        ScrollView(.vertical) {
                            
                            VStack(spacing: .DesignSystem.Spacing.xl) {
                                
                                VStack(spacing: .DesignSystem.Spacing.m) {
                                    
                                    ProfilePictureLarge(
                                        pictureUrl: model.pictureUrl,
                                        text: user.firstName + " " + user.lastName,
                                        action: user.id == userManager.user?.id ? onTapProfilePicture : nil
                                    )
                                    
                                    if errorCamera {
                                        
                                        Text("Camera unavailable")
                                            .font(.DesignSystem.body2(weight: .bold))
                                            .foregroundStyle(Color.red)
                                        
                                    }
                                    
                                }
                                
                                VStack(spacing: .DesignSystem.Spacing.xl) {
                                    
                                    ForEach(0..<model.filteredPosts.count, id: \.self) { i in
                                        
                                        VStack(spacing: .DesignSystem.Spacing.m) {
                                            
                                            Text(model.filteredPosts[i].first?.created.formatRelativeDay() ?? "Unknown Date")
                                                .font(.DesignSystem.subtitle1(weight: .bold))
                                                .foregroundStyle(Color.primary)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.leading, .DesignSystem.Spacing.xl)
                                            
                                            PostThumbnailCarousel3(
                                                posts: model.filteredPosts[i].sorted(by: { $0.created < $1.created }),
                                                showDate: false,
                                                tapAction: onTapPost(_:))
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            .padding(.top, navBarHeight + .DesignSystem.Spacing.s)
                            
                        }
                        .scrollIndicators(.hidden)
                        
                    } else {
                        
                        VStack(spacing: .DesignSystem.Spacing.xl) {
                            
                            VStack(spacing: .DesignSystem.Spacing.m) {
                                
                                ProfilePictureLarge(
                                    pictureUrl: model.pictureUrl,
                                    text: user.firstName + " " + user.lastName,
                                    action: user.id == userManager.user?.id ? onTapProfilePicture : nil
                                )
                                
                                if errorCamera {
                                    
                                    Text("Camera unavailable")
                                        .font(.DesignSystem.body2(weight: .bold))
                                        .foregroundStyle(Color.red)
                                    
                                }
                                
                            }
                            
                            Spacer()
                            
                            TextPlaceholder(
                                title: emptyPlaceholderTitle(),
                                subtitle: emptyPlaceholderSubtitle(),
                                buttonTitle: nil,
                                action: nil
                            )
                            .padding(.horizontal, .DesignSystem.Spacing.xl)
                            .padding(.bottom, .DesignSystem.Spacing.xxl)
                            
                            Spacer()
                            Spacer()
                            
                        }
                        .padding(.top, navBarHeight + .DesignSystem.Spacing.s)
                        
                    }
                    
                } else {
                    
                    TextPlaceholder(
                        title: "Something went wrong",
                        subtitle: "No user found",
                        buttonTitle: nil,
                        action: nil
                    )
                    .padding(.horizontal, .DesignSystem.Spacing.xl)
                    
                }
                
            }
            
            HStack(spacing: 0) {
                
                ImageButton(
                    image: Image(systemName: "chevron.left"),
                    color: .primary,
                    contentMode: .fit,
                    size: .init(width: 20, height: 26),
                    action: onTapBack
                )
                .padding(.trailing, .DesignSystem.Spacing.l)
                .contentShape(Rectangle())
                
                Spacer()
                
                if user?.id == userManager.user?.id {
                
                    Button(action: onTapDisconnect) {
                        Text("Disconnect")
                            .font(.DesignSystem.body2(weight: .medium))
                            .foregroundStyle(Color.primary)
                            .contentShape(Rectangle())
                    }
                    
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, .DesignSystem.Spacing.s)
            .padding(.bottom, .DesignSystem.Spacing.m)
            .padding(.horizontal, .DesignSystem.Spacing.l)
            .background(
                BlurEffect(style: .regular)
                    .ignoresSafeArea(.all)
            )
            .heightRecorder { value in
                navBarHeight = value
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
        }
        .sheet(isPresented: $presentCamera) {
            CameraPicker(imageCompletion: model.imageCompletion(result:))
                .background(
                    Color.black
                )
        }
        .onReceive(timer) { _ in
            if timerErrorCamera > 0 {
                timerErrorCamera -= 0.1
            } else {
                timerErrorCamera = 0
                withAnimation(.easeOut(duration: 0.2)) {
                    errorCamera = false
                }
            }
        }
        .toolbar(.hidden)
        .onAppear(perform: onAppear)
    }
    
    // MARK: Privates
    
    private func onAppear() -> Void {
        model.initDatas(with: user)
    }
    
    private func emptyPlaceholderTitle() -> String {
        if user?.id == userManager.user?.id {
            return "No post yet"
        }
        return "Nothing here"
    }
    
    private func emptyPlaceholderSubtitle() -> String {
        if user?.id == userManager.user?.id {
            return "Share a post to see it here"
        }
        return "This user has not shared anything yet"
    }
    
    private func openApplicationSystemSettings() -> Void {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: Actions
    
    private func onTapBack() -> Void {
        isPresented = false
    }
    
    private func onTapProfilePicture() -> Void {
        if UIImagePickerController.isCameraDeviceAvailable(.front) || UIImagePickerController.isCameraDeviceAvailable(.rear) {
            let authorization = AVCaptureDevice.authorizationStatus(for: .video)
            if authorization == .authorized || authorization == .notDetermined {
                presentCamera = true
            } else {
                openApplicationSystemSettings()
            }
        } else {
            timerErrorCamera = 3
            withAnimation(.easeOut(duration: 0.2)) {
                errorCamera = true
            }
        }
    }
    
    private func onTapPost(_ post: Post) -> Void {
        
    }
    
    private func onTapDisconnect() -> Void {
        userManager.disconnect()
    }
}

// MARK: - Previews

#Preview {
    UserProfile(isPresented: .constant(true), user: .randomUser())
}
