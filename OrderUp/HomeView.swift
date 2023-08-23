//
//  ContentView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 6/2/23.
//

import SwiftUI



struct HomeView: View {
    //TODO: Need to add a dismiss in the enviromnment!!
    //managed object
    
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var firebaseManager: FirebaseManager
    
        //the fetched array of Vendor items from Core Data.
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var StoreItems: FetchedResults<Item>
    
    @State private var showingAddItemScreen = false
    var body: some View {
        
        NavigationView {
            ZStack {
                List {
                    ForEach(StoreItems) {item in
                        NavigationLink {
                            //class for sheet is here
                            EditItemDetailsView(item: item, itemID: item.id!)
                                //this is the item, so will actually do the saving here!
                                //or will change the items list here, 
                            
                        } label: {
                            
                            VStack(alignment: .leading, spacing:25) {
                                HStack {
                                    let itemImage = UIImage(data: item.image!)
                                    
                                    let imageDisplayed = Image(uiImage: itemImage!)
                                   
                                    imageDisplayed
                                        .resizable()
                                        .frame(width:100,height: 100)
                                        .cornerRadius(25)
                                        .scaledToFit()
                                        .border(.red)
                                    
                                    
                                    VStack(alignment: .leading, spacing:12) {
                                        Text(item.name ?? "")
                                        
                                        
                                        Text("Price: " + item.price.formatted())
                                    }
                                    .border(.red)
                                    .padding(.leading,50)
                                    //.padding(EdgeInsets( leading: 2))
                                    
                                }
                              
                                Text(item.itemDescription!)
                                    .multilineTextAlignment(.leading)
                                    //.padding([.top],20)//dont format siunce you have string
                                    .border(.red)
                                    
                            }
                            
                        }
                        .padding()
                       
                    }
                   //Spacer()
                    .onDelete(perform: deleteItems)
                    .background(RoundedRectangle(cornerRadius: 12).fill(.white))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 4, leading: -5, bottom: 4, trailing:-5)) //edge insets set the ditance the elemetns inside the row, is shrunk or grown?
                }
                .listStyle(.insetGrouped)
                
               
                .navigationTitle("My Items")
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
                .sheet(isPresented: $showingAddItemScreen) {
                   newItemUploadView()
                }
                
                AddItemButton(showingScreen: $showingAddItemScreen)
                
            
            }
        }
    }
    
        //may need to add an alert for this
    
    func deleteItems(at offsets:IndexSet) {
        
        
        //ah, this deletes an item at the specifed offset, in the list. likley can save the offset
        //but will have to change this fucntion to maybe run when the list changes as well
        for offset in offsets {
            let storeItem = StoreItems[offset]
            
            firebaseManager.deleteVendorItem(itemID: storeItem.id!) {result in
                if(result) {
                    moc.delete(storeItem)
                }
            }
        }
        
        try? moc.save()
    
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
