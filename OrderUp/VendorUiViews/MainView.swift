//
//  MainView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 7/3/23.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var firebaseManager = FirebaseManager()
   
    //sign up View Model which will be seen throughout the environment
//TODO: Fix this according to my understanding of environment object. 
//    if !loginStatus  {
//        VendorSignUpView()
//            .environmentObject(signUpViewModel)
//            .navigationTitle("Login")
//
//        //passes into the environment
//    }
    var body: some View {
        //likley need to place the logic
        
       
        TabView {
            HomeView().tabItem {
                Label("My Items", systemImage:"list.dash")
                
            }
            //add more tabs here to work with.
            OrdersView().tabItem {
                Label("Orders", systemImage: "rectangle.portrait.and.arrow.right")
            }
            
        }
        .environmentObject(firebaseManager)
        
       
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
