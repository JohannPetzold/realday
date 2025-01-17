//
//  UINavigationController+Extension.swift
//  realday
//
//  Created by Johann Petzold on 17/01/2025.
//

import Foundation
import SwiftUI

extension UINavigationController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
