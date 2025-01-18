//
//  NewPost.swift
//  realday
//
//  Created by Johann Petzold on 18/01/2025.
//

import SwiftUI
import DesignSystem
import PhotosUI

// MARK: - New Post

struct NewPost: View {
    
    // MARK: Properties
    
    @Binding var isPresented: Bool
    
    // MARK: States
    
    @StateObject private var model: NewPostViewModel = NewPostViewModel()
    @State private var navBarHeight: CGFloat = 0
    @State private var presentCamera: Bool = false
    @State private var errorCamera: Bool = false
    @State private var timerErrorCamera: Double = 0
    @FocusState private var focusedField: Focus?
    @State private var fieldFocus: Bool = false
    
    private enum Focus: Int, Hashable {
        case caption
    }
    
    // MARK: Constants
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    // MARK: Layout
    
    var body: some View {
        ZStack {
            
            VStack(spacing: .DesignSystem.Spacing.l) {
                
                Text("Take a photo and add a caption to show your day!")
                    .font(.DesignSystem.subtitle1(weight: .bold))
                    .foregroundStyle(Color.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, .DesignSystem.Spacing.xxxl)
                
                Spacer()
                
                ZStack {
                 
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(model.image == nil ? Color.DesignSystem.skeletonBackground : .clear)
                        
                    VStack(spacing: .DesignSystem.Spacing.m) {
                        
                        Button(action: onTapTakePicture) {
                            Image(systemName: "camera")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .foregroundStyle(Color.white)
                                .frame(width: 64, height: 64)
                                .background(
                                    BlurEffect(style: .systemUltraThinMaterialDark)
                                )
                                .clipShape(Circle())
                                .contentShape(Circle())
                        }
                        
                        if errorCamera {
                            
                            Text("Camera unavailable")
                                .font(.DesignSystem.body2(weight: .bold))
                                .foregroundStyle(Color.red)
                            
                        }
                        
                    }
                    
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, .DesignSystem.Spacing.l)
                    
                }
                .background(
                    Group {
                        if let uiImage = model.image {
                            
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .clipped()
                            
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, .DesignSystem.Spacing.l)
                
                VStack(spacing: .DesignSystem.Spacing.xs) {
                    
                    HStack(spacing: 0) {
                        
                        Text("Caption")
                            .font(.DesignSystem.body1(weight: .bold))
                            .foregroundStyle(Color.primary)
                        
                        Spacer()
                        
                        Text("\(model.caption.count)/\(model.captionMaxLenght)")
                            .font(.DesignSystem.sub1(weight: .bold))
                            .foregroundStyle(Color.primary)
                        
                    }
                
                    TextEditor(text: $model.caption)
                        .frame(maxWidth: .infinity)
                        .frame(height: 164)
                        .padding(.horizontal, .DesignSystem.Spacing.xs)
                        .padding(.vertical, .DesignSystem.Spacing.xs)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary, lineWidth: 2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .font(.DesignSystem.body1(weight: .regular))
                        .foregroundStyle(Color.primary)
                        .keyboardType(.default)
                        .focused($focusedField, equals: .caption)
                        .onTapGesture {
                            focusedField = .caption
                        }
                    
                }
                .padding(.horizontal, .DesignSystem.Spacing.l)
                
                TextButton(
                    text: "Confirm",
                    type: .blue,
                    font: .DesignSystem.body1(weight: .bold),
                    isLoading: false,
                    disabled: model.image == nil,
                    action: onTapConfirm
                )
                .padding(.horizontal, .DesignSystem.Spacing.l)
                .padding(.bottom, .DesignSystem.Spacing.m)
                
            }
            .padding(.top, navBarHeight)
            
            ImageButton(
                image: Image(systemName: "chevron.down"),
                color: .primary,
                contentMode: .fit,
                size: .init(width: 20, height: 26),
                action: onTapBack
            )
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing, .DesignSystem.Spacing.l)
            .padding(.top, .DesignSystem.Spacing.s)
            .padding(.bottom, .DesignSystem.Spacing.m)
            .padding(.horizontal, .DesignSystem.Spacing.l)
            .heightRecorder { value in
                navBarHeight = value
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            fieldFocus = false
        }
        .onChange(of: focusedField) { oldValue, newValue in
            if newValue != nil {
                fieldFocus = true
            }
        }
        .onChange(of: fieldFocus) { oldValue, newValue in
            if !newValue {
                focusedField = nil
            }
        }
        .onChange(of: model.caption) { oldValue, newValue in
            onChangeCaption(newValue: newValue)
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
        .sheet(isPresented: $presentCamera) {
            CameraPicker(imageCompletion: model.imageCompletion(result:))
                .background(
                    Color.black
                )
        }
    }
    
    // MARK: Privates
    
    private func onChangeCaption(newValue: String) -> Void {
        model.caption = String(newValue.prefix(model.captionMaxLenght))
    }
    
    private func openApplicationSystemSettings() -> Void {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: Actions
    
    private func onTapBack() -> Void {
        isPresented = false
    }
    
    private func onTapTakePicture() -> Void {
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
    
    private func onTapConfirm() -> Void {
        model.savePost {
            isPresented = false
        }
    }
}

// MARK: - Previews

#Preview {
    NewPost(isPresented: .constant(true))
}
