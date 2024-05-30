//
//  UserChoiceView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 11/6/23.
//

import SwiftUI
import Firebase

///  Screen to allow user to choose whether to sign up as vendor or customer, Will be the root navigation view
struct UserChoiceView: View {
    //ZStack here
    @EnvironmentObject var navRouter: Router
    
    @EnvironmentObject var authModel:AuthenticationViewModel
    
//    @State var currentUser: User? = nil
    
    var loggedInUserType = UserDefaults.standard.getCurrentUserLoggedInType()
    
    var body: some View {
        ZStack {
            if authModel.currentUser != nil {
                if loggedInUserType == "Vendor" {
                    VendorHomeView()
                } else if loggedInUserType == "Customer" {
                    CustomerHomeView()
                }
            } else {
                NavigationStack(path: $navRouter.loginNavPath) {
                    VStack {
                        
                        NavigationLink(destination: VendorSignUpView()) {
                            Text("Vendors")
                                .frame(width: 170, height: 50)
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                                .cornerRadius(25)
                        }
                        
                        NavigationLink("Customerss") {
                            
                        }
                        .frame(width: 170, height: 50)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(25)
                    }
                    .navigationDestination(for: ScreenRouter.self) { screen in
                        switch screen {
                        case .VendorScreen:
                            VendorSignUpView()
                        case .CustomerScreen:
                            CustomerSearchandItemDisplayView()
                        case .choiceScreen:
                            UserChoiceView()
                                .navigationBarBackButtonHidden(true)
                        case .VendorPhoneAuthScreen:
                            PhoneAuthView(userType: "vendor")
                        case .VendorHomeScreen:
                            VendorTabs(selection: VendorTabsScreens.itemsScreen)
                                .navigationBarBackButtonHidden(true)
                        }
                    }
                  
                    }
             
                

            }
        }
        .onDisappear {
            authModel.monitorAuthState()
        }
        
        
        
     
    }
    
    
    
    
}

struct UserChoiceView_Previews: PreviewProvider {
    static var previews: some View {
        UserChoiceView()
    }
}
