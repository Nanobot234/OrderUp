//
//  FSAuthManager.swift
//  OrderUp
//
//  Created by Nana Bonsu on 2/12/24.
//

import Foundation
import FirebaseFirestore
import Firebase
import SwiftUI


///  Defines all the operations related to authenticating a user in Firebase
class FSAuthManager {
    
    
    static let shared = FSAuthManager()

    let db = Firestore.firestore()
    
    var errMessage = ""

    
    
    //Add the viewModel here

    func phoneNumberVerfication(countryCode:String,mobileNumber:String,completion: @escaping (Any) -> Void) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber("+\(countryCode + mobileNumber)", uiDelegate: nil) { idCredential, err in
            
            print("Starting to Run this")
            //TODO: Check for the error and place right , error handling
            
            if let err = err {
                
                let verifyError = err as NSError
                
                switch verifyError.code {
                case AuthErrorCode.invalidPhoneNumber.rawValue:
                    
                    self.errMessage = "Invalid Phone Number"
                    completion(false)
                default:
                    print(verifyError.localizedDescription)
                }
                
            }
            
            completion(idCredential!)
           
            
            
        }
    }
    
    //first clean up variables
    //then set the error code, or messages
    //then delete from aiuthentication model
    func userSignIn(phoneCredential:String,phoneVerificationCode:String) -> [String]  {
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: phoneCredential, verificationCode: phoneVerificationCode)
        
        Auth.auth().signIn (with: credential) { result, err in
            
            if let error = err{
                
                let signInError = error as NSError
                
                //TODO: Add errors awithc statements here!
              //  self.authModel.phoneSignInErrorMessage = error.localizedDescription
                return
            }
            // user Successfully Logged In....
            //result?.user.uid the user ID!
            
            
           //this is userdefaults
            self.authModel.vendorAuthID = result!.user.uid
    
            //now will check if vendorCode exists in userDefaults if not will create it
            
            
            //create vendor code! then save it in user defaulta,
            
            //change app storage here, and then instantie homeview!
            
            //this can be saved in user defaults as well

            let values = [result!.user.uid,"true"]
            //TODO: Check if nav bar (back button)can be hidden on a certain page
            
        }
    }
    
    /// Retrives the vendor code from local storage if it exists, or creates one if it doesnt
    ///
    /// The vendor code is always tied to the authID of the current logged in user. When a new vendor code is created, the code is also saved in Firebase.
    /// - Parameter completion: <#completion description#>
    func getOrCreateVendorCode(completion: @escaping (String) -> ()) {
        
        //check if he vendor code is there, if not will create it for the ID that is passed in
     
        //check here if not in userDefualts
        
        //check first if there is a vendor Code,
        if(UserDefaults.standard.string(forKey: authModel.vendorAuthID) == nil) {
  
            let newVendorCode = self.createVendorCode()
            
            UserDefaults.standard.set(newVendorCode, forKey: authModel.vendorAuthID) //save the vendorCode into userCefaults with the key being the currently logged in user
            FirebaseFirestoreManager.shared.setFeildDataForVendor(vendorID: newVendorCode, dataValue: newVendorCode, dataParameter: "vendorCode") //save to
            completion(newVendorCode)
        } else {
            let vendorCode = UserDefaults.standard.string(forKey: authModel.vendorAuthID)!
            completion(vendorCode)
        }
        //case where
        
       
    }
    
    
    
    /// creates a random 5 digit alphamueric vendor code
    /// - Returns: the vendor code
    func createVendorCode() -> String {
        
        let uuid = UUID().uuidString
        let vendorCode = String(uuid.prefix(5))
        return vendorCode
      
    }
    
    
}
