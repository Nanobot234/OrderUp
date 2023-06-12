//
//  ImagePickerandTaker.swift
//  OrderUp
//
//  Created by Nana Bonsu on 6/14/23.
//

import Foundation
import UIKit
import SwiftUI
import PhotosUI


//make a struct for image then make others



struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType
    
   
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        
        func picker(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else { return }
            self.parent.selectedImage = selectedImage
            self.parent.isPresented.wrappedValue.dismiss()
        }
        
    }

    func makeUIViewController(context: Context) -> some UIImagePickerController {
        var imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        
        //let picker = PHPickerViewController(configuration: config)
    
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self) //calling the class, with the Coordinator
    }
    
}
