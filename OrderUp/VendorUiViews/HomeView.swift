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
    @EnvironmentObject var signUpModel: SignUpViewModel //this gets the signUp model from the environment
   
        //the fetched array of Vendor items from Core Data.
    
    @EnvironmentObject var navRouter: Router
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var StoreItems: FetchedResults<Item>
    
    @State private var showingAddItemScreen = false
    
    init() {
     //   showingAddItemScreen = signUpModel.showSMSCodeVerification
    }
    
    var body: some View {
        
        //now need to check the environment
        NavigationStack {
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
                                    
                                    
                                    VStack(alignment: .leading, spacing:20) {
                                        Text(item.name ?? "")
                                            .font(.system(size: 20))
                                            .multilineTextAlignment(.leading)
                                        //.padding()
                                        
                                        
                                        //Text("Price: " + item.price.formatted())
                                        
                                        Text("Price not set yet")
                                            .font(.system(size: 20))
                                    }
                                    .padding(.leading,50)
                                    //.padding(EdgeInsets( leading: 2))
                                    
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
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 4, leading: -5, bottom: 4, trailing:-5)) //edge insets set the ditance the elemetns inside the row, is shrunk or grown?
                }
                .listStyle(.insetGrouped)
                
                //                .navigationDestination(isPresented: $showingAddItemScreen, destination: {
                //                    PhoneAuthView()
                //                })
                
                
                
                .navigationTitle("My Items")
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Sign out") {
                            navRouter.loginNavPath.append(Router.ScreenRouter.choiceScreen)
                        }
                    }
                }
                .sheet(isPresented: $showingAddItemScreen) {
                    newItemUploadView()
                }
                
                AddItemButton(showingScreen: $showingAddItemScreen)
                
                
            }
        }
        
    }
    
    
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
