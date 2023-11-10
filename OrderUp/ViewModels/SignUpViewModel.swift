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


@MainActor class SignUpViewModel:ObservableObject {
    
    
    //action button state
    
    @Published var loginStatus: Bool {
        didSet {
            UserDefaults.standard.set(loginStatus,forKey: "log_Status")
        } //will change the login status based oon this line here!, updates the environment as well
       
    }
    
    
    
    @Published var mobileNumber: String = ""
    @Published var countryCode: String = ""
    
    @Published var email: String = ""
    @Published var password = ""
    @Published var phoneVerificationCode = ""
    
    @Published var showAlert = false
    @Published var errorMessage = "" //error message that is shown when phone auth has a problem
    //verifies if you have 10 digit number!
    
    //Verification ID credential
    @Published var idCredential = ""
   

    
    /// boolean to decide when to display phone authentication view
   // @Published var showSMSCodeVerification = false
    
    
    ///Not sure if the following code is needed tho!!
    init() {
        self.loginStatus = UserDefaults.standard.bool(forKey: "log_Status")
        }
    
    //escaping function here!!
    func verifyUserPhoneNumber(completion: @escaping (String) -> Void) {
        
     
         print("Got here at least")
        PhoneAuthProvider.provider().verifyPhoneNumber("+\(countryCode + mobileNumber)", uiDelegate: nil) { idCredential, err in
            print("Starting to Run this")
            
            if let err = err {
                self.errorMessage = err.localizedDescription
                print(self.errorMessage)
                self.showAlert.toggle()
                completion("false")
                return
                
            }
            
            self.idCredential = idCredential!
            completion("true")
          //  self.showSMSCodeVerification = true
           // DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
               // self.alertWithTF()
            
        
            
            
        }
    }
  
  
    func LoginUser() {
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.idCredential, verificationCode: phoneVerificationCode)
        
        
        Auth.auth().signIn (with: credential) { result, err in
            if let error = err{
                self.errorMessage = error.localizedDescription
                self.showAlert.toggle()
                return
            }
            // user Successfully Logged In....
            
            //change app storage here, and then instantie homeview!
            self.loginStatus = true
            print(self.loginStatus)
         //   HomeView()
            
        }
    }
    

    func reportError() {
        
        
    }
}



// Loggin in User...
