//
//  FSAuthManager.swift
//  OrderUp
//
//  Created by Nana Bonsu on 2/12/24.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseFirestore


///  Defines all the operations related to authenticating a user in Firebase
class FSAuthManager {
    
    
    static let shared = FSAuthManager()

    let db = Firestore.firestore()
    
    var errMessage = ""

    
    
    ///
    
    /// <#Description#>
    /// - Parameters:
    ///   - countryCode: <#countryCode description#>
    ///   - mobileNumber: <#mobileNumber description#>
    ///   - completion: <#completion description#>
    func phoneNumberVerfication(countryCode:String,mobileNumber:String,completion: @escaping (String?,String?) -> Void) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber("+\(countryCode + mobileNumber)", uiDelegate: nil) { idCredential, err in
            
            print("Starting to Run this")
            //TODO: Check for the error and place right , error handling
            
            if let err = err {
                
                let verifyError = err as NSError
                
                let errorMessage = FirebaseErrors.getFbAuthErrorMessage(fbErrorCode: verifyError.code)
                
                completion(nil,errorMessage)
                
            }
            
            completion(idCredential!,nil)
           
            
            
        }
    }
    
    //first clean up variables
    //then set the error code, or messages
    //then delete from aiuthentication model
    
    
    ///  Signs in a desired user then performs various  database operations if so
    /// - Parameters:
    ///   - phoneCredential: <#phoneCredential description#>
    ///   - phoneVerificationCode: <#phoneVerificationCode description#>
    ///   - userType: <#userType description#>
    ///   - completion: <#completion description#>
    func userSignIn(phoneCredential:String,phoneVerificationCode:String,userType: String, completion:@escaping (String?,String?) -> Void)  {
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: phoneCredential, verificationCode: phoneVerificationCode)
 
        Auth.auth().signIn (with: credential) { result, err in
            
            if let signInerror = err {

                let verifyError =  signInerror as NSError //(Make into one)
                
                let errorMessage = FirebaseErrors.getFbAuthErrorMessage(fbErrorCode: verifyError.code)
                     
                completion(nil,errorMessage)
                }

            let signInResult = result!.user.uid
            
            if userType == "vendor" {
                
                //can check if
                UserDefaults.standard.set(result!.user.uid, forKey: "vendorAuthID") //sets the current logged in vendors iD, into the local storage            
                self.getOrCreateVendorCode(vendorAuthID: result!.user.uid) //create the vendor code for the user here
            } else if userType == "customer" {
                // set te id and other t
                UserDefaults.standard.set(result!.user.uid, forKey: "customerAuthID")
                //maybe more here
            }
            
            completion(signInResult,nil)
           
            //TODO: Check if nav bar (back button)can be hidden on a certain page
            
        }
 
    }
    
    /// Retrives the vendor code from local storage if it exists, or creates one if it doesnt
    ///
    /// The vendor code is always tied to the authID of the current logged in user. When a new vendor code is created, the code is also saved in Firebase.
    /// - Parameter completion: <#completion description#>
    func getOrCreateVendorCode(vendorAuthID:String) {
        
       //ok so need to make sure if the auth ID
        
        //checks if vendorAuthId hasnt been created yet.
        if(UserDefaults.standard.string(forKey: vendorAuthID) == nil) {
            
            //need to store the
                //check if firebase has a vendorCode for that authID
            let newVendorCode = self.createVendorCode()
            
            UserDefaults.standard.set(newVendorCode, forKey: vendorAuthID) //save the vendorCode into userCefaults with the key being the currently logged in user
            FirebaseFirestoreManager.shared.setFeildDataForVendor(vendorID: newVendorCode, dataValue: newVendorCode, dataParameter: "vendorCode") //save to
            FirebaseFirestoreManager.shared.setFeildDataForVendor(vendorID: newVendorCode, dataValue: vendorAuthID, dataParameter: "authID")
           
        } else {
            let vendorCode = UserDefaults.standard.string(forKey: vendorAuthID)!
           
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
