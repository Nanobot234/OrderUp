//
//  UserChoiceView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 11/6/23.
//

import SwiftUI

///  Screen to allow user to choose whether to sign up as vendor or customer, Will be the root navigation view
struct UserChoiceView: View {
    
    @EnvironmentObject var navRouter: Router
    
    var body: some View {
        
        VStack {
           
//            Button("Vendors") {
//
//            }
            
            NavigationLink("Vendors", value: ScreenRouter.VendorScreen)
                .frame(width: 170, height: 50)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(25)
            
        }
        
        
     
    }
    
    
    
    
}

struct UserChoiceView_Previews: PreviewProvider {
    static var previews: some View {
        UserChoiceView()
    }
}
