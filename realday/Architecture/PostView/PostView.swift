//
//  PostView.swift
//  realday
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI
import Models

// MARK: - Post View

struct PostView: View {
    
    // MARK: Properties
    
    @Binding var isPresented: Bool
    let post: Post
    
    // MARK: Layout
    
    var body: some View {
        Text(post.created.formatDayMonthHourMinute())
    }
}

// MARK: - Previews

#Preview {
    PostView(isPresented: .constant(true), post: .randomPost())
}
