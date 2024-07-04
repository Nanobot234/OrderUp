//
//  ContentView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 6/2/23.
//

import SwiftUI
import CoreData


/// Screen that displays items being sold by the authenticated vendor
struct VendorHomeView: View {
    //TODO: Need to add a dismiss in the enviromnment!!
    //managed object
    
    
    
    @Environment(\.managedObjectContext) var moc
    //can be observed
    
    /// used to navigate between the sign up flows
    @EnvironmentObject var navRouter: Router
    @Environment(\.dismiss) var dismiss
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) private var StoreItems: FetchedResults<Item>
    
    @EnvironmentObject var authModel: AuthenticationViewModel
    
    @State var showingNewItemView: Bool = false
    @State private var showingAddItemScreen = false
    @State var showingEdititemView: Bool = false
    @State var vendorCode = ""
    
    /// the item that the user selects. This item has details that are thus displayed to the user.
    @State private var selectedItem: Item? = nil
    
    var body: some View {
        
        //now need to check the environment
        NavigationView {
            
            ZStack {
                VStack {
                    Text("Vendor Code" + vendorCode)
                        .font(.headline) //Check here?
                    //  Can change this here!!
                    ItemList
                }
                
                
                .navigationTitle("My Items")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarBackButtonHidden(true)
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        Button("Sign Out") {
                            withAnimation {
                                authModel.vendorLoginStatus = false
                                navRouter.loginNavPath.removeLast(navRouter.loginNavPath  .count)
                                authModel.signOutUser()
                            }
                        }
                        
                    }
                }
                AddItemButton(showingScreen: $showingAddItemScreen)
            }
            .overlay(alignment: .center) {
                noItemsOverLay
            }
        }
        //shows a sheet with the selecteditem details!!
        .sheet(item: $selectedItem, onDismiss: dismissSheet , content: { item in
            EditItemDetailsView(item: item)
              
        })
        
        //                .sheet(isPresented: $showingEdititemView) {
        //                    EditItemDetailsView(item: selectedItem!)
        //                }
        .sheet(isPresented: $showingAddItemScreen) {
            NewItemUploadView()
               
        }
        .onAppear {
               vendorCode = UserDefaults.standard.getCurrentVendorCode() //get the current vendor code
            authModel.stopMonitoringAuthState()
            print("Store Items Count:" + StoreItems.count.formatted())
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
    func dismissSheet() {
        dismiss()
    }

    // MARK: The row of items
    var ItemList: some View {
        
        List {
            ForEach(StoreItems) {(item: Item) in
                //here the view is clickable really
                Section {
                    
                    
                    itemRowView(item: item)
                        .background(RoundedRectangle(cornerRadius: 12).fill(.white))
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: -5, bottom: 4, trailing:-5))
                    }
                }
            .onDelete(perform: deleteItems)
            }
            //Spacer()
           
            .background(RoundedRectangle(cornerRadius: 12).fill(.white))
            .listStyle(.insetGrouped)
//            .listRowSeparator(.hidden)
           // .listRowInsets(EdgeInsets(top: 4, leading: -5, bottom: 4, trailing:-5)) //edge insets set the ditance the elemetns inside the row, is shrunk or grown?
        }
     
    
    
    var noItemsOverLay: some View {
        if(StoreItems.isEmpty) {
            return AnyView(
                VStack(spacing: 10) {
                    Text("No Items")
                        .font(.system(size:30))
                        .fontWeight(.bold)
                    Text("Press the add button to add items")
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    func printFirstItem() {
        
        print("First item name" + (StoreItems[0].name ?? ""))
    }
    
    
    /// Item details thats displayed in a list for the user! Change it up and add it here! Also view the trello ifo for board!
    func itemRowView(item: Item) -> some View {
    
        Button(action: {
            selectedItem = item
        }) {
            VStack(alignment: .leading, spacing:25) {
                HStack {
                    let itemImage = UIImage(data: item.image ?? Data() )
                    
                    let imageDisplayed = Image(uiImage: itemImage ?? UIImage())
                    
                    imageDisplayed
                        .resizable()
                        .frame(width:100,height: 100)
                        .cornerRadius(25)

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
                
                Text(item.itemDescription ?? "")
                    .font(.system(size: 20, design: .serif))
                    .multilineTextAlignment(.leading)
                //.padding([.top],20)//dont format siunce you have string
                
            }
        }
       
    }
}


//struct for the button at the bottom of the screen
struct AddItemButton: View {
    
    @Binding var showingScreen: Bool //Rename this well!!
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Button {
                    self.showingScreen.toggle()
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
        VendorHomeView()
    }
}
