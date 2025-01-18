//
//  UIApplication+Extension.swift
//  Models
//
//  Created by Johann Petzold on 18/01/2025.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    public static var safeAreaInsets: UIEdgeInsets = {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first?.safeAreaInsets ?? .zero
    }()
}
