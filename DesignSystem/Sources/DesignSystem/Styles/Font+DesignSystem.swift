//
//  Font+DesignSystem.swift
//  DesignSystem
//
//  Created by Johann Petzold on 16/01/2025.
//

import Foundation
import SwiftUI

extension Font {
    
    public enum DesignSystem {
        
        /// Design System `Headline 1` font, size `40`.
        public static func h1(weight: Font.Weight) -> Font {
            return .system(size: 40, weight: weight)
        }
        
        /// Design System `Headline 2` font, size `32`.
        public static func h2(weight: Font.Weight) -> Font {
            return .system(size: 32, weight: weight)
        }
        
        /// Design System `Headline 3` font, size `24`.
        public static func h3(weight: Font.Weight) -> Font {
            return .system(size: 24, weight: weight)
        }
        
        /// Design System `Subtitle 1` font, size `20`.
        public static func subtitle1(weight: Font.Weight) -> Font {
            return .system(size: 20, weight: weight)
        }
        
        /// Design System `Body 1` font, size `16`.
        public static func body1(weight: Font.Weight) -> Font {
            return .system(size: 16, weight: weight)
        }
        
        /// Design System `Body 2` font, size `14`.
        public static func body2(weight: Font.Weight) -> Font {
            return .system(size: 14, weight: weight)
        }
        
        /// Design System `Sub 1` font, size `12`.
        public static func sub1(weight: Font.Weight) -> Font {
            return .system(size: 12, weight: weight)
        }
    }
}
