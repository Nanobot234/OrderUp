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
    
    @EnvironmentObject var persistenceControl: PersistenceController
//    @State var currentUser: User? = nil
    
    @State var isFirebaseConfigured = false
    /// Tracks the current logged in user type as to whether its a vendor or customer.
    var loggedInUserType = UserDefaults.standard.getCurrentUserLoggedInType()
    
    var body: some View {
        NavigationStack(path: $navRouter.loginNavPath)  {
      
        
                if authModel.currentUser == nil {
                    //displaying buttons to allow users to sign in!
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
                                VendorHomeView()
//                                VendorTabs()
//                                    .navigationBarBackButtonHidden(true)
                            }
                        }
                        
                    }
            else {
                VendorTabs()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationBarBackButtonHidden(true)
            }
               
        }
        .onChange(of: authModel.currentUser) { user in
            //when a vendor has logged in then
//            if user != nil && loggedInUserType == "Vendor" {
//                navRouter.loginNavPath.append(ScreenRouter.CustomerScreen)
//            }
        }
                  
        .onDisappear {
            authModel.monitorAuthState()
        }
        .onAppear {
       //     persistenceControl.deletePersistentStore()
        }

    }
    
    /// checks if Firebase is configured
    func configureFireabse() {
        if FirebaseApp.app() == nil {
                    FirebaseApp.configure()
                }
                // Ensure Firebase is configured
                if FirebaseApp.app() != nil {
                    isFirebaseConfigured = true
                    authModel.monitorAuthState()
                } else {
                    // Handle configuration failure
                    print("Failed to configure Firebase")
                }
    }
    
    
    
}

struct UserChoiceView_Previews: PreviewProvider {
    static var previews: some View {
        UserChoiceView()
    }
}
