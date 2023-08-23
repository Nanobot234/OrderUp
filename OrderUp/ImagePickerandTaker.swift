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
   // let completionHandler: (Result<UIImage, Error>?) -> Void
    
    
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
   
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        //   let completionHandler: (Result<UIImage, Error>?) -> Void
        
        init(_ parent: ImagePicker) {
            //  self.completionHandler = completionHandler
            self.parent = parent
        }
        
        
        //            //   func picker(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //
        //
        //            if let selectedImage = info[.originalImage] as? UIImage {
        ////                print("This is selected image data",selectedImage.description)
        ////                completionHandler(.success(selectedImage))
        //                parent.selectedImage = selectedImage
        //                parent.isPresented.wrappedValue.dismiss()
        //            } else {
        //                print("Loser")
        //             //   completionHandler(nil)
        //            }
        //
        //
        //            //print("This is selected image data",selectedImage.description)
        //            //self.parent.selectedImage = selectedImage
        //
        //            //now implement the completion handler?
        //           // picker.dismiss(animated: true)
        //        }
        //
        //    }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.selectedImage = selectedImage
                
            }
            parent.isPresented.wrappedValue.dismiss()
        }
    }

    func makeUIViewController(context: Context) -> some UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        
        //let picker = PHPickerViewController(configuration: config)
    
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self) //calling the class, with the Coordinator
    }
    
}
