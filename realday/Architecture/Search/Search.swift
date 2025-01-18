//
//  Search.swift
//  realday
//
//  Created by Johann Petzold on 18/01/2025.
//

import SwiftUI
import DesignSystem
import Models

// MARK: - Search

struct Search: View {
    
    // MARK: Properties
    
    @Binding var isPresented: Bool
    
    // MARK: States
    
    @StateObject private var model: SearchViewModel = SearchViewModel()
    @StateObject private var appManager: AppManager = .shared
    @State private var isUserPresented: Bool = false
    @State private var presentedUser: User? = nil
    @FocusState private var focusedField: Focus?
    @State private var fieldFocus: Bool = false
    
    private enum Focus: Int, Hashable {
        case search
    }
    
    // MARK: Layout
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: .DesignSystem.Spacing.s) {
                
                ZStack {
                    
                    ImageButton(
                        image: Image(systemName: "chevron.down"),
                        color: .primary,
                        contentMode: .fit,
                        size: .init(width: 20, height: 26),
                        action: onTapBack
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Looking for new friends?")
                        .font(.DesignSystem.subtitle1(weight: .bold))
                        .foregroundStyle(Color.primary)
                    
                }
                .padding(.horizontal, .DesignSystem.Spacing.l)
                .padding(.top, .DesignSystem.Spacing.s)
                .padding(.bottom, .DesignSystem.Spacing.m)
                
                VStack(spacing: .DesignSystem.Spacing.l) {
                    
                    HStack(spacing: .DesignSystem.Spacing.s) {
                        
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        ZStack(alignment: .leading) {
                            
                            if model.search.isEmpty {
                                
                                Text("Find new friends")
                                    .font(.DesignSystem.body1(weight: .medium))
                                    .foregroundStyle(Color.secondary)
                                
                            }
                            
                            TextField("", text: $model.search)
                                .font(.DesignSystem.body1(weight: .medium))
                                .foregroundStyle(Color.primary)
                                .autocorrectionDisabled()
                                .focused($focusedField, equals: .search)
                            
                        }
                        
                        if !model.search.isEmpty {
                            
                            Button(action: onTapClear) {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color.primary)
                                    .contentShape(Circle())
                            }
                            
                        }
                        
                    }
                    .padding(.horizontal, .DesignSystem.Spacing.l)
                    .frame(height: 42)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary, lineWidth: 2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .contentShape(RoundedRectangle(cornerRadius: 8))
                    .onTapGesture {
                        focusedField = .search
                    }
                    .padding(.horizontal, .DesignSystem.Spacing.l)
                    
                    if model.search.isEmpty && model.searchUsers.isEmpty {
                        
                        Spacer()
                        
                    } else if !model.search.isEmpty {
                        
                        if model.searchUsers.isEmpty {
                            
                            Spacer()
                            
                            TextPlaceholder(
                                title: "No user found",
                                subtitle: "Try a different search",
                                buttonTitle: nil,
                                action: nil
                            )
                            .padding(.horizontal, .DesignSystem.Spacing.xl)
                            
                            Spacer()
                            
                        } else {
                            
                            ScrollView(.vertical) {
                                
                                LazyVStack(spacing: .DesignSystem.Spacing.l) {
                                    
                                    ForEach(model.searchUsers) { user in
                                        
                                        SearchUserItem(
                                            user: user,
                                            isFollowed: appManager.usersFollowed.contains(where: { $0.id == user.id }),
                                            action: onTapItemUser,
                                            followAction: onTapFollowUser
                                        )
                                        
                                    }
                                    
                                }
                                .padding(.horizontal, .DesignSystem.Spacing.l)
                                
                            }
                            .scrollIndicators(.hidden)
                            
                        }
                        
                    } else {
                        
                        Spacer()
                        
                    }
                    
                }
                
            }
            .navigationDestination(isPresented: $isUserPresented) {
                UserProfile(isPresented: $isUserPresented, user: presentedUser)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                fieldFocus = false
            }
        
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
        .onChange(of: model.search) { oldValue, newValue in
            onChangeSearch(newValue: newValue)
        }
    }
    
    // MARK: Privates
    
    private func onChangeSearch(newValue: String) -> Void {
        model.search = String(newValue.prefix(100))
        model.updateSearchUsers()
    }
    
    // MARK: Actions
    
    private func onTapBack() -> Void {
        isPresented = false
    }
    
    private func onTapClear() -> Void {
        model.search = ""
    }
    
    private func onTapItemUser(_ user: User) -> Void {
        presentedUser = user
        isUserPresented = true
    }
    
    private func onTapFollowUser(_ user: User) -> Void {
        if let index = appManager.usersFollowed.firstIndex(where: { $0.id == user.id }) {
            appManager.usersFollowed.remove(at: index)
        } else {
            appManager.usersFollowed.append(user)
        }
    }
}

// MARK: - Previews

#Preview {
    Search(isPresented: .constant(true))
}
