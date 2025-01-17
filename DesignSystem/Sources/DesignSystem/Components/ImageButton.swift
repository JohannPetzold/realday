//
//  ImageButton.swift
//  DesignSystem
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI

// MARK: - Image Button

public struct ImageButton: View {
    
    // MARK: Properties
    
    private let image: Image
    private let color: Color
    private let contentMode: ContentMode
    private let size: CGSize
    private let action: (() -> Void)?
    
    // MARK: Init
    
    public init(image: Image, color: Color, contentMode: ContentMode, size: CGSize, action: @escaping () -> Void) {
        self.image = image
        self.color = color
        self.contentMode = contentMode
        self.size = size
        self.action = action
    }
    
    fileprivate init(image: Image, color: Color, contentMode: ContentMode, size: CGSize) {
        self.image = image
        self.color = color
        self.contentMode = contentMode
        self.size = size
        self.action = nil
    }
    
    // MARK: Layout
    
    public var body: some View {
        Button(action: onTap) {
            image
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .frame(width: size.width, height: size.height)
                .foregroundStyle(color)
                .contentShape(Rectangle())
        }
    }
    
    // MARK: Actions
    
    private func onTap() -> Void {
        if let action {
            action()
        }
    }
}

// MARK: - Previews

#Preview {
    ImageButton(image: Image(systemName: "xmark"), color: .black, contentMode: .fit, size: .init(width: 20, height: 20))
}
