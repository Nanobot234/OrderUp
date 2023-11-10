//
//  newItemUploadView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 6/9/23.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

//this view will present a form for th  user to upload a new item, which will be display on main screen and eventaully saved in CoreData and firebase!


struct newItemUploadView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    
    //these states should be in a ViewModel class, where I publish the changes to the view correctly
    @State private var itemName = ""
    @State private var itemDescription = ""
    @State private var itemPrice = "0.0"
    @State private var itemUploadError = false //error that will display a message to the user if the form entry is missing
    //now set the source type for
    @State private var userSelectedImage: UIImage?
    @State private var displayImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @EnvironmentObject var firebaseManager: FirebaseManager
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        
        NavigationView {
            
            Form {
                if userSelectedImage != nil {
                    Image(uiImage: userSelectedImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200,height: 200)
                    
                }
                else {
                    Text("No Photo Selected")
                        .frame(width: 200, height: 200,alignment:.center)
                }
                
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
                
                Section {
                    TextField("Whats is the price you want to charge", text: $itemPrice).keyboardType(.decimalPad)
                    //keypad here
                }
                
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        //will need to do more checks here
                        if(itemName.isEmpty || userSelectedImage == nil) {
                            print("You thought")
                            itemUploadError = true
                        } else {
                            let item = Item(context: moc)
                            
                            item.image = userSelectedImage?.jpegData(compressionQuality: 0.8)
                            item.name = itemName
                            item.itemDescription = itemDescription
                            item.price = Double(itemPrice)!
                            item.id = String(UUID().uuidString.prefix(4))
                            firebaseManager.writeToFirebase(itemName: itemName, itemDescription: itemDescription, itemPrice: Double(itemPrice) ?? 0.0, image: userSelectedImage!, itemID: item.id!) //saving it to firebase now
                            try? moc.save()
                            
                            //dismisses on main thread, is helful I guess
                            DispatchQueue.main.async {
                                dismiss()
                            }
                        
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
    
    
    //writes the items to firebase, will
  
    
    //need to write function to store image!
 
}



//struct newItemUploadView_Previews: PreviewProvider {
//    static var previews: some View {
//        newItemUploadView( sourceType: .photoLibrary)
//    }
//}
