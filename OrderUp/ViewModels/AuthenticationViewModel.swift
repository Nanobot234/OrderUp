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
     
     //@StateObject var navRouter = Router()
     
     @Published var currentUser: User?
     

    @Published var vendorLoginStatus: Bool {
        didSet {
            UserDefaults.standard.set(vendorLoginStatus,forKey: "vendor_login_status")
            
        } //will change the login status based oon this line here!, updates the environment as well
  
    }
     
     @Published var customerLoginStatus: Bool {
         didSet {
             UserDefaults.standard.set(vendorLoginStatus,forKey: "customer_login_status")
             
         }
         
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

     private var handle: AuthStateDidChangeListenerHandle? //handle to use for auth state listener changes.
     
    /// boolean to decide when to display phone authentication view
   // @Published var showSMSCodeVerification = false
    
    
    ///Not sure if the following code is needed tho!!
    init() {
        self.vendorLoginStatus = UserDefaults.standard.bool(forKey: "vendor_login_status") //each view will know the login status?
        self.vendorAuthID = UserDefaults.standard.string(forKey: "vendorAuthID") ?? ""
        self.currentUser = Auth.auth().currentUser //gets the current user
        self.customerLoginStatus = UserDefaults.standard.bool(forKey: "customer_login_status")
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
     
     /// Signs in a vendor accoutnw ith their phonenumber
     /// - Parameter completion: <#completion description#>
     func vendorSignIn() {
          
         FSAuthManager.shared.userSignIn(phoneCredential: phoneVerificationCredential, phoneVerificationCode: phoneVerificationCode, userType: "vendor") { resultarr, errMsg in
             
             if(resultarr != nil) {
                 self.vendorAuthID = resultarr!//this is the uid thats generated
                 UserDefaults.standard.setCurrentUserLoggedInType(userType: "Vendor") //sets the logged in user as a vendor
                //want to set the current logged in user
                 
               //  completion(true)
             } else {
                 self.phoneSignInErrorMessage = errMsg!
                // completion(false)
             }
         }
     }
  
     
     /// check for changes in the authentication state of the current user
     func monitorAuthState() {
         ///
         handle = Auth.auth().addStateDidChangeListener({ auth, user in
             self.currentUser = user
             if let _ = user {
                 if UserDefaults.standard.getCurrentUserLoggedInType() == "Vendor" {
                     self.vendorLoginStatus = true
                 } else if UserDefaults.standard.getCurrentUserLoggedInType() == "Customer" {
                     self.customerLoginStatus = true
                     //
                 }
             }
             //now check to see if there is a recent user with the
             //
         })
     }
     
     /// stop listening for authentication changes
     ///
     /// Used when a view disappears.
     func stopMonitoringAuthState() {
         
         if let handle = handle {
             Auth.auth().removeStateDidChangeListener(handle)
         }
     }
    
     
     func signOutUser() {
         do {
            
                 try Auth.auth().signOut()
                 self.currentUser = nil
                 //continue from here!!
             } catch {
                 //more here/
                 
      
             }
         }
    

}



// Loggin in User...
