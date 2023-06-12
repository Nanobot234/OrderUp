//
//  newItemUploadView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 6/9/23.
//

import SwiftUI
import PhotosUI

//this view will present a form for th  user to upload a new item, which will be display on main screen and eventaully saved in CoreData and firebase!


struct newItemUploadView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @State private var itemName = ""
    @State private var itemDescription = ""
    @State private var itemPrice = 0.0
    @State private var itemUploadError = false //error that will display a message to the user if the form entry is missing
    //now set the source type for
    @State private var userSelectedImage:UIImage?
    @State private var displayImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
      
        NavigationView {
            
            
            
            Form {
                //define more here
                //will need a feature to let user take a photo of item or chose onlien!!
                
                //image
                
//                Button("Hello") {
//                    print("Clicked me")
//                }
                //Align Form elements in the center
                ImageView(selectedImage: $userSelectedImage, imagePickerDisplay: self.$displayImagePicker)
                
                Button("Take a Photo") {
                    self.sourceType = .camera
                    print(self.sourceType == .camera)
                    self.displayImagePicker.toggle()
                    print(self.displayImagePicker.description)
                    
                }.padding()
                
                Button("Choose an existing photo") {
                   self.sourceType = .photoLibrary
                    self.displayImagePicker.toggle()
                }.padding()
                
                Section {
                    TextField("What is the name of this item?", text: $itemName)
                    

                    TextField("Any Extra things?", text: $itemDescription)
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        //will need to do more checks here
                        if(itemName.isEmpty || userSelectedImage == nil) {
                            itemUploadError = true
                        } else {
                            let item = Item(context: moc)
        
                            item.image = userSelectedImage?.jpegData(compressionQuality: 0.8)
                            item.name = itemName
                            item.itemDescription = itemDescription
                            item.price = itemPrice
                            try? moc.save()
                            dismiss()
                            
                        }
                        
                    }
                    
                }
            }
            .navigationTitle("Add a new item")
            
            .navigationBarTitleDisplayMode(.inline)
            
            //alert if there is a problem
            .alert("Cant Save Your Item", isPresented: $itemUploadError) {
                Button("Ok") {}
            } message: {
                Text("Make sure that you have selected an image and you  have entered a name for your item")
            }
            
            .sheet(isPresented: self.$displayImagePicker) {
              
                ImagePicker(selectedImage: self.$userSelectedImage, sourceType: self.sourceType)

            }
        }
        
    }
}


struct ImageView: View {
    @Binding var selectedImage: UIImage? //this image will be pased in the struct, that will let it be shown, placed in this struct
    @Binding var imagePickerDisplay: Bool//showing the picker for image
   // @Binding  var sourceType: UIImagePickerController.SourceType
    //
    var body: some View {
        //here put in the code for the image to be displayed that the user took or selected?
        //or else just have a buttom
        VStack {
            if selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200,height: 200)
                
            }  else {
                Text("No Photo Selected")
                    .frame(width: 200, height: 200,alignment:.center)
                    
                    
            }
           
        }
        
    }
}

//struct newItemUploadView_Previews: PreviewProvider {
//    static var previews: some View {
//        newItemUploadView( sourceType: .photoLibrary)
//    }
//}
