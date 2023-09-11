//
//  editItemDetailsView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 8/2/23.
//

import SwiftUI
import PhotosUI

struct EditItemDetailsView: View {
    
    //the item to be edited
    var item:Item
    var itemID:String
   // var onSave:(Item) -> Void
    
    //following variables are what can be edited to be saved
    @State private var newItemName:String
    @State private var newItemDescription: String
    @State private var newItemImageData: Data
    @State private var newItemPrice: Double
    //@State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var imageToDisplay:UIImage?
    @State private var displayImagePicker = false
    
    //private var myItems: FetchedResults<Item>
    @Environment(\.managedObjectContext) var managedViewContext
    
    @EnvironmentObject var firebaseManager: FirebaseManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @FetchRequest private var myItems: FetchedResults<Item>
//   @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "id == %@",itemID)) var myFetchedItems: FetchedResults<Item>
    
    
    var body: some View {
       
        
        //here will need to change the items borht in fireabse and coredata!
        //Form here as wwell
       
            Form {
                
                Section {
                    //here goes the image
                    
                    
                    Image(uiImage: imageToDisplay!)
                        .resizable()
                        .scaledToFit()
                    
                    Button("Take a Photo") {
                        //   self.sourceType = .camera
                        // print(self.sourceType == .camera)
                        self.displayImagePicker.toggle()
                        print(self.displayImagePicker.description)
                        
                    }.padding()
                    
                    Button("Choose an existing photo") {
                        //   self.sourceType = .photoLibrary
                        self.displayImagePicker.toggle()
                    }.padding()
                    
                }
                
                Section {
                    TextField("What is the name of this item?", text: $newItemName)
                    TextField("Any Extra things?", text: $newItemDescription)
                    
                    //TextField(
                }
            }
        
        .navigationTitle("Edit The Item")
        .navigationBarTitleDisplayMode(.inline)
        
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                 
                        Button("Save") {
                            
                            //will need to fetch it with the id from Coredata, and then save it to firebase with that id as well
            
                            fetchFomCoreDatandEditWithID(items: myItems)
                        }
                  
                   
                }
            }
            .sheet(isPresented: $displayImagePicker) {
               
                ImagePicker(selectedImage: self.$imageToDisplay)
                
            }
            
    }
    
    //initializer for class variabels
//onSave: @escaping (Item) -> Void
    init(item: Item,itemID:String) {
        self.item = item
        self.itemID = itemID //sets the member functions itemID
        //self.onSave = onSave
        
        _newItemName = State(initialValue: item.name!)
        _newItemDescription = State(initialValue: item.itemDescription!)
        _newItemPrice = State(initialValue: item.price)
        _newItemImageData = State(initialValue: item.image!)
        
        _myItems = FetchRequest(sortDescriptors: [],
                                predicate: NSPredicate(format: "id == %@", self.itemID),
                                animation: .default)
        
        _imageToDisplay = State(initialValue: UIImage(data: self.newItemImageData))
     
    }
    
    
    
    /// Updates item then resaves in coreData also uploads to Firebase
    ///
    /// - Parameter items: <#items description#>
    func fetchFomCoreDatandEditWithID(items: FetchedResults<Item>) {
        
       
        
        if let fetchedItem = items.first {
            //now will change the items here and then save it back in coreData
            
            //not reached//
            fetchedItem.image = self.imageToDisplay?.jpegData(compressionQuality: 0.8) //this should be the new image gotten
            fetchedItem.name = self.newItemName
            fetchedItem.itemDescription = self.newItemDescription
            fetchedItem.price = self.newItemPrice
            
            //write the chnaged info to fireabse
            self.firebaseManager.writeToFirebase(itemName: fetchedItem.name!, itemDescription:fetchedItem.itemDescription! , itemPrice: fetchedItem.price, image: UIImage(data: fetchedItem.image!)!, itemID: fetchedItem.id!)
            
            do {
                try managedViewContext.save()
                
                //go back to
                
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("\(error.localizedDescription)")
            }
            
        }
    }
}

//struct editItemDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditItemDetailsView()
//            .environment(\.managedObjectContext, PersistenceController.)
//
//    }
//}
