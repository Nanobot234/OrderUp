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


struct NewItemUploadView: View {

    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    //these states should be in a ViewModel class, where I publish the changes to the view correctly
    @State private var itemName = ""
    @State private var itemDescription = ""
    @State private var itemPrice = 0.0
    @State private var itemUploadError = false //error that will display a message to the user if the form entry is missing
    //now set the source type for
    @State private var userSelectedImage: UIImage?
    @State private var displayImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    //@Binding var showingScreen: Bool
    var numberFormatter: NumberFormatter = NumberFormatter()
    
    
   
    
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
                } header: {
                    Text("Item name")
                }
//                
                Section {
                   // TextField("Any Extra things?", text: $itemDescription)
                    TextEditor(text: $itemDescription)
                        .foregroundStyle(.primary)
                        .padding(.horizontal)
                } header: {
                    Text("Item Description")
                }
                
                Section {
                    TextField("$0.00",value: $itemPrice, formatter: numberFormatter)
                        .keyboardType(.decimalPad)
                    //Maybe check for a way that first element doesnt have to be deleted
                    //keypad here
                } header: {
                    Text("Item Price")
                }
                
                Section {
                    ConfirmationButton(title:"Publish") {
                        let item = Item(context: moc)
                        saveOrUploadItem(reason: "localsave&firebase", item: item)
                    }
                }
            }
            
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button("Save For Later") {
                        //will need to do more checks here
                        let item = Item(context: moc) 
                        saveOrUploadItem(reason: "localsave", item: item)
                        
                    }
                    
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                            dismiss()
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
        .onAppear {
       //     numberFormatter.numberStyle = .currency
          //  numberFormatter.maximumFractionDigits = 2
          //  showingScreen = true
        }
        
    }
    
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - reason: <#reason description#>
    ///   - item: <#item description#>
    func saveOrUploadItem(reason:String, item: Item) {
        
        if reason == "localsave" {
            if(itemName.isEmpty || userSelectedImage == nil) {
                print("You thought")
                itemUploadError = true
            } else {
                
                //Create an item object and then save it in coreData.
                
                item.image = userSelectedImage?.jpegData(compressionQuality: 0.8)
                item.name = itemName
                item.itemDescription = itemDescription
                item.price = itemPrice
                item.id = String(UUID().uuidString.prefix(4))
                
                //Prevent this one!
                
                try? moc.save()
                dismiss()
                
            }
            
        } else if reason == "localsave&firebase" {
            
            //save both here!
            item.image = userSelectedImage?.jpegData(compressionQuality: 0.8)
            item.name = itemName
            item.itemDescription = itemDescription
            item.price = itemPrice
            item.id = String(UUID().uuidString.prefix(4))
            
            //Prevent this one!
            
            try? moc.save()
            dismiss()
            
            DispatchQueue.main.async {
                FirebaseFirestoreManager.shared.uploadNewVendorItem(itemName: item.name!, itemDescription:item.itemDescription! , itemPrice: item.price, image: UIImage(data: item.image!)!, itemID: item.id!)
            }
            
        }
    }
}



//struct newItemUploadView_Previews: PreviewProvider {
//    static var previews: some View {
//        newItemUploadView( sourceType: .photoLibrary)
//    }
//}
