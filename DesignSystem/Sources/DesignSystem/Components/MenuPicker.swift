//
//  MenuPicker.swift
//  DesignSystem
//
//  Created by Johann Petzold on 17/01/2025.
//

import SwiftUI

// MARK: - Menu Picker

public struct MenuPicker<Content: View>: View {
    
    // MARK: Properties
    
    private let buttons: [PickerAction]
    @ViewBuilder let content: Content
    
    // MARK: Init
    
    public init(buttons: [PickerAction], content: () -> Content) {
        self.buttons = buttons
        self.content = content()
    }
    
    // MARK: Layout
    
    public var body: some View {
        Menu {
            ForEach(0..<buttons.count, id:\.self) { i in
                Button(action: buttons[i].action) {
                    if let image = buttons[i].image {
                        Label {
                            Text(buttons[i].text)
                        } icon: {
                            Image(systemName: image)
                        }
                    } else {
                        Text(buttons[i].text)
                    }
                }
            }
        } label: {
            content
        }
    }
}

// MARK: - Picker Action

public struct PickerAction {
    
    // MARK: Properties
    
    var text: String
    var image: String? = nil
    var action: () -> Void
    
    // MARK: Init
    
    public init(text: String, image: String? = nil, action: @escaping () -> Void) {
        self.text = text
        self.image = image
        self.action = action
    }
}

// MARK: - Previews

#Preview {
    Group {
        MenuPicker(buttons: []) {
            Text("Menu")
        }
    }
}
