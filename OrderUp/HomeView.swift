//
//  ContentView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 6/2/23.
//

import SwiftUI



struct HomeView: View {
    //TODO: Need to add a dismiss in the enviromnment!!
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var StoreItems: FetchedResults<Item>
    
    @State private var showingAddItemScreen = false
    var body: some View {
        
        NavigationView {
            ZStack {
                List {
                    ForEach(StoreItems) {item in
                        NavigationLink {
                            //class for sheet is here
                        } label: {
                            
                    
                            VStack {
                                HStack {
                                    
                                    //                                Rectangle()
                                    //                                    .frame(width: 100,height:100)
                                    //                                    .foregroundColor(Color.gray)
                                    
                                   
                                    
                                    let itemImage = UIImage(data: item.image!)
                                    
                                    let imageDisplayed = Image(uiImage: itemImage!)
                                   
                                    
                                    imageDisplayed
                                        .resizable()
                                        .frame(width:100,height: 100)
                                        .cornerRadius(25)
                                        .scaledToFit()
                                    
                                    
                                   
                                    
                                    VStack {
                                        Text(item.name ?? "")
                                            .padding()
                                        Text("Price: " + item.price.formatted())
                                        
                                        
                                    }
                                    .padding(.leading,50)
                                    //.padding(EdgeInsets( leading: 2))
                                    
                                    
                                }
                                //adding floating button in the bottom of the screen!!
                                
                                Text(item.itemDescription!)
                                    .padding([.top],20)//dont format siunce you have string
            
                            }
                            
                        }
                        .padding()
                       
                    }
                   //Spacer()
                    .background(RoundedRectangle(cornerRadius: 12).fill(.white))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 4, leading: -5, bottom: 4, trailing:-5)) //edge insets set the ditance the elemetns inside the row, is shrunk or grown?
                }
                .listStyle(.insetGrouped)
                
               
                .navigationTitle("My Items")
                
                .sheet(isPresented: $showingAddItemScreen) {
                   newItemUploadView()
                }
                
                AddItemButton(showingScreen: $showingAddItemScreen)
                
            }
        }
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
