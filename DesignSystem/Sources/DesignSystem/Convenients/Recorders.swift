//
//  Recorders.swift
//  DesignSystem
//
//  Created by Johann Petzold on 17/01/2025.
//

import Foundation
import SwiftUI

extension View {
    
    @ViewBuilder public func heightRecorder(update: @escaping (_ value: CGFloat) -> Void) -> some View {
        self
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(key: CGFloatPreferenceKey.self, value: proxy.size.height)
                }
            )
            .onPreferenceChange(CGFloatPreferenceKey.self, perform: update)
    }
}

public struct CGFloatPreferenceKey: @preconcurrency PreferenceKey {
    
    @MainActor public static var defaultValue: CGFloat = 0
    
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    }
}
