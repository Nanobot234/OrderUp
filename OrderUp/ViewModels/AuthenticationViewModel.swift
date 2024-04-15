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


///  manages authentication and sign in in the application
 class AuthenticationViewModel:ObservableObject {
     
     @StateObject var navRouter = Router()

    @Published var vendorLoginStatus: Bool {
        didSet {
            UserDefaults.standard.set(vendorLoginStatus,forKey: "vendor_login_status")
            
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
        self.vendorLoginStatus = UserDefaults.standard.bool(forKey: "vendor_login_status")
        self.vendorAuthID = UserDefaults.standard.string(forKey: "vendorAuthID") ?? ""
//
        }
    
    //escaping function here!!
    
    // Think this needs to be in the FireStore operations!
     func verifyPhoneNumber() {
         
         FSAuthManager.shared.phoneNumberVerfication(countryCode: countryCode, mobileNumber: userMobileNumber) { idCredential, errMsg in
             
             if(idCredential != nil) {
                 self.phoneVerificationCredential = idCredential!
             } else {
                 self.phoneSignInErrorMessage = errMsg!
             }
         }
     }
     
     func vendorSignIn(completion: @escaping (Bool) -> Void) {
          
         FSAuthManager.shared.userSignIn(phoneCredential: phoneVerificationCredential, phoneVerificationCode: phoneVerificationCode) { resultarr, errMsg in
             
             if(resultarr != nil) {
                 self.vendorAuthID = resultarr![0]
                 self.vendorLoginStatus = Bool(resultarr![1])!
                 UserDefaults.standard.setCurrentUserLoggedInType(userType: "Vendor") //sets the logged in user as a vendor
                //want to set the current logged in user
                 completion(true)
             } else {
                 self.phoneSignInErrorMessage = errMsg!
                 completion(false)
             }
         }
     }
  
    
    

}



// Loggin in User...
