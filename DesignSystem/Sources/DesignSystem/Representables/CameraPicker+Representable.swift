//
//  CameraPicker+Representable.swift
//  DesignSystem
//
//  Created by Johann Petzold on 17/01/2025.
//

import Foundation
import SwiftUI
import OSLog
import Models

// MARK: - Logger

fileprivate let logger: Logger = .init(subsystem: "RealDay", category: "CameraPicker")

// MARK: - Camera Picker

public struct CameraPicker: UIViewControllerRepresentable {

    // MARK: Properties
    
    private var imageCompletion: (Result<UIImage, Error>) -> Void
    
    // MARK: Environment
    
    @Environment(\.presentationMode) private var presentationMode
    
    // MARK: Init
    
    public init(imageCompletion: @escaping (Result<UIImage, Error>) -> Void) {
        self.imageCompletion = imageCompletion
    }
    
    // MARK: Representable
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<CameraPicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    // MARK: Coordinator
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: CameraPicker
        
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[.originalImage] as? UIImage {
                
                if let imageUrl = info[.imageURL] as? URL {
                    try? FileStorageManager.deleteFile(url: imageUrl)
                }
                parent.imageCompletion(.success(image))
                
            } else if let imageUrl = info[.imageURL] as? URL, let image = UIImage(contentsOfFile: imageUrl.path) {
                
                try? FileStorageManager.deleteFile(url: imageUrl)
                parent.imageCompletion(.success(image))
                
            } else {
                logger.error("Error taking picture")
                parent.imageCompletion(.failure(CameraError.cameraPickerFailed))
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

extension CameraPicker {
    
    enum CameraError: Error {
        case cameraPickerFailed
        
        func errorDescription() -> String {
            switch self {
            case .cameraPickerFailed:
                return "Camera Picker Failed"
            }
        }
    }
}
