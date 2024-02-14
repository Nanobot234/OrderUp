//
//  OrdersViewModel.swift
//  OrderUp
//
//  Created by Nana Bonsu on 7/26/23.
//

import Foundation
import ActionButton
import Firebase
import SwiftUI
///this class will fetch the custoemr orders from the firebase

//each order will have an order id, and an array of order items


//Model class supports phone Number authentication for now
//might need to change name toLOgin


 class AuthenticationViewModel:ObservableObject {

    @Published var loginStatus: Bool {
        didSet {
            UserDefaults.standard.set(loginStatus,forKey: "log_Status")
        } //will change the login status based oon this line here!, updates the environment as well
       
    }
    
    ///  The auth ID of the vendor
    ///
    ///  When a vendor signs up with their phone number, they are provided with randomly generared UID from Firestore. This UID is the same when the vendor signs in as well!
    @Published var vendorAuthID: String {
        didSet {
            UserDefaults.standard.set(vendorAuthID, forKey: "vendorAuthID")
        }
            
    

    }
    
    
    @Published var userMobileNumber: String = ""
    @Published var countryCode: String = ""
    
    @Published var email: String = ""
    @Published var password = ""
   
    
    @Published var showAlert = false
    @Published var phoneVerificationErrorMessage = "" //error message that is shown when phone auth has a problem
    //verifies if you have 10 digit number!
    
    //Verification ID credential
    @Published var phoneVerificationCredential = ""
    
    ///  The SMS code sent to the users  device to enabel them to sign in
    @Published var phoneVerificationCode = ""
    
    @Published var phoneSignInErrorMessage = ""

    
    /// boolean to decide when to display phone authentication view
   // @Published var showSMSCodeVerification = false
    
    
    ///Not sure if the following code is needed tho!!
    init() {
        self.loginStatus = UserDefaults.standard.bool(forKey: "log_Status")
        self.vendorAuthID = UserDefaults.standard.string(forKey: "vendorAuthID") ?? ""
//
        }
    
    //escaping function here!!
    
    // Think this needs to be in the FireStore operations!
    
  
    
    

}



// Loggin in User...
