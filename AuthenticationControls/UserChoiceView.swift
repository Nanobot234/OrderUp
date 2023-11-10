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
            
            NavigationLink("Vendors", value: Router.ScreenRouter.VendorScreen)
                .frame(width: 150, height: 50)
                .background(Color.blue)
                .foregroundColor(Color.white)
                    
            }
        
        //Customers will come here soon!
        .navigationDestination(for: Router.ScreenRouter.self) { screen in
            switch screen {
            case .VendorScreen:
                VendorSignUpView()
            case .CustomerScreen:
                CustomerSearchandItemDisplayView()
            case .choiceScreen:
                    UserChoiceView()
            case .PhoneAuthScreen:
                PhoneAuthView()
        }
    }
        }
       
       
    
    
}

struct UserChoiceView_Previews: PreviewProvider {
    static var previews: some View {
        UserChoiceView()
    }
}
