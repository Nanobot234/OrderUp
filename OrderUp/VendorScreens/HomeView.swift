//
//  ContentView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 6/2/23.
//

import SwiftUI
import CoreData


/// Screen that displays items being sold by the logged in vendor
struct HomeView: View {
    //TODO: Need to add a dismiss in the enviromnment!!
    //managed object
    
    
//    var vendorID = UserDefaults.standard.string(forKey: "userID")
    
    @Environment(\.managedObjectContext) var moc
    
    @EnvironmentObject var navRouter: Router //used to navigate...
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var StoreItems: FetchedResults<Item>
    
    @State private var showingAddItemScreen = false
    @State var vendorCode = ""


    var body: some View {
        
        //now need to check the environment
        NavigationView {
                
            ZStack {
                
                VStack {
                    Text("Vendor Code" + vendorCode)
                        .font(.headline) //Check here?
                    ItemList
                }
         
                .navigationTitle("My Items")
                .navigationBarTitleDisplayMode(.large)
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        
                       // NavigationLink("Sign Out", value: Router.ScreenRouter.choiceScreen)
     
                        Button("Sign out") {
                       //     navRouter.loginNavPath.append(Router.ScreenRouter.PhoneAuthScreen)
                            navRouter.popToRoot = true
                        }
                    }
                }
                .sheet(isPresented: $showingAddItemScreen) {
                    newItemUploadView()
                }
                
                AddItemButton(showingScreen: $showingAddItemScreen)
                
                
            }
        }
        .onAppear {
         //   vendorCode = UserDefaults.standard.getCurrentVendorCode()

        }
        
    }
    
    
    /// Deletes a specific item from the list and in the Firebase Database
    ///
    /// The item at the offset index is deleted from the list..
    /// - Parameter offsets: the index to delete the Item from
    func deleteItems(at offsets:IndexSet) {
        
      
        for offset in offsets {
            let storeItem = StoreItems[offset]
            
            FirebaseFirestoreManager.shared.deleteVendorItem(itemID: storeItem.id!) {result in
                if(result) {
                    moc.delete(storeItem)
                }
            }
        }
        
        try? moc.save()
    
    }
    
    var ItemList: some View {
        List {
            ForEach(StoreItems) {(item: Item) in
                NavigationLink {
                    //class for sheet is here
                    EditItemDetailsView(item: item)
               
                } label: {
                    
                    //Make this into various fonts to work wi
                    VStack(alignment: .leading, spacing:25) {
                        HStack {
                            let itemImage = UIImage(data: item.image!)
                            
                            let imageDisplayed = Image(uiImage: itemImage!)
                            
                            imageDisplayed
                                .resizable()
                                .frame(width:100,height: 100)
                                .cornerRadius(25)
                                .scaledToFit()
                            
                            
                            VStack(alignment: .leading, spacing:20) {
                                
                                Text("Item Name: " + (item.name ?? ""))
                            //TODO: good fonts for the text size!
                                    .font(.system(size: 20))
                                    .multilineTextAlignment(.leading)
             
                                Text(item.price > 0.0 ? "Price: " + item.price.formatted() : "Price not set yet")
                                    .font(.system(size: 20))
                            }
                            .padding(.leading,50)
                          
                        }
                        
                        Text(item.itemDescription!)
                            .font(.system(size: 20, design: .serif))
                            .multilineTextAlignment(.leading)
                        //.padding([.top],20)//dont format siunce you have string
                        
                    }
                    
                }
                .padding()
                
            }
            //Spacer()
            .onDelete(perform: deleteItems)
            .background(RoundedRectangle(cornerRadius: 12).fill(.white))
            
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 4, leading: -5, bottom: 4, trailing:-5)) //edge insets set the ditance the elemetns inside the row, is shrunk or grown?
        }
        .listStyle(.insetGrouped)

    }
}
 

//struct for the button at the bottom of the screen
struct AddItemButton: View {
    
    @Binding var showingScreen: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                
                Button {
                    showingScreen.toggle()
                } label: {
                    Text("Add an Item")
                        .font(.system(.largeTitle))
                        .frame(width: 250, height: 50, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(25)
                }

            }
            .padding(.bottom)
            
        }
        .foregroundColor(Color.red)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
