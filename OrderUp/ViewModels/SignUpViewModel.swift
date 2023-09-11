//
//  OrdersViewModel.swift
//  OrderUp
//
//  Created by Nana Bonsu on 7/26/23.
//

import Foundation
import ActionButton
import Firebase
///this class will fetch the custoemr orders from the firebase

//each order will have an order id, and an array of order items


//Model class supports phone Number authentication for now
//might need to change name toLOgin

@MainActor class SignUpViewModel:ObservableObject {
    
    
    //action button state
    
    
    @Published var mobileNumber: String = ""
    @Published var countryCode: String = ""
    
    @Published var email: String = ""
    @Published var password = ""
    @Published var phoneVerificationId = ""
    
    @Published var showAlert = false
    @Published var errorMessage = "" //error message that is shown when phone auth has a problem
    //verifies if you have 10 digit number!
    
    //Verification ID credential
    @Published var idCredential = ""
   
    
    private func verifyUserPhoneNumber() {
        PhoneAuthProvider.provider().verifyPhoneNumber("+\(countryCode + mobileNumber)", uiDelegate: nil) {idCredential, err in
            
            if let err = err {
                self.errorMessage = err.localizedDescription
                self.showAlert.toggle()
                return
            }
            self.idCredential = idCredential!
            
            
        }
    }
    
    //veriication with textBox
    func alertWithTF() {
        
        let alert = UIAlertController(title: "Verfication", message: "Enter the OTP Code", preferredStyle: .alert)
            
        alert.addTextField { text in
            text.placeholder = "123456"
        }
        
        //now add an alert actiom
        
        //add actions for two modes
        alert.addAction(UIAlertAction(title: "Cance;", style: .destructive, handler: nil))
        //alert.addAction(UIAlertAction)
        
    }
    
    //continue, and look at other thing
//    private func verifyCodeAndSignUp() {
//        let credential = PhoneAuthProvider.provider().credential(withVerificationID: <#T##String#>, verificationCode: <#T##String#>)
//        Auth.auth().signIn(with: credential) {_, err in
//            if let err = err {
//                print(err.localizedDescription)
//            } else {
//                print("User signed in with number")
//                //function to sign up new user!
//            }
//            
//        }
//    }
    
}
