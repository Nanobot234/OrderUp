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

/// Defines all the operations related to authenticating a user in Firebase
class FSAuthManager {

    /// Singleton instance of FSAuthManager
    static let shared = FSAuthManager()

    private let db = Firestore.firestore()

    /// Verifies a phone number using Firebase authentication
    /// - Parameters:
    ///   - countryCode: The country code of the user's phone number
    ///   - mobileNumber: The user's mobile number
    ///   - completion: Completion handler with optional verification ID and error message
    func phoneNumberVerification(countryCode: String, mobileNumber: String, completion: @escaping (String?, String?) -> Void) {
        let fullPhoneNumber = "+\(countryCode)\(mobileNumber)"
        
        PhoneAuthProvider.provider().verifyPhoneNumber(fullPhoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                let verifyError = error as NSError
                let errorMessage = FirebaseErrors.getFbAuthErrorMessage(fbErrorCode: verifyError.code)
                completion(nil, errorMessage)
            } else {
                completion(verificationID, nil)
            }
        }
    }

    /// Signs in a user using phone authentication and performs database operations based on user type
    /// - Parameters:
    ///   - phoneCredential: The verification ID received after phone number verification
    ///   - phoneVerificationCode: The verification code sent to the user's phone
    ///   - userType: The type of user (e.g., "vendor" or "customer")
    ///   - completion: Completion handler with optional user ID and error message
    func userSignIn(phoneCredential: String, phoneVerificationCode: String, userType: String, completion: @escaping (String?, String?) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: phoneCredential, verificationCode: phoneVerificationCode)

        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                let verifyError = error as NSError
                let errorMessage = FirebaseErrors.getFbAuthErrorMessage(fbErrorCode: verifyError.code)
                completion(nil, errorMessage)
            } else if let user = result?.user {
                let userID = user.uid
                UserDefaults.standard.set(userID, forKey: userType == "vendor" ? "vendorAuthID" : "customerAuthID")

                if userType == "vendor" {
                    self.getOrCreateVendorCode(vendorAuthID: userID)
                }
                completion(userID, nil)
            } else {
                completion(nil, "Unknown error occurred during sign-in.")
            }
        }
    }

    /// Retrieves the vendor code from local storage or creates one if it doesn't exist
    /// - Parameter vendorAuthID: The authentication ID of the vendor
    func getOrCreateVendorCode(vendorAuthID: String) {
        if UserDefaults.standard.string(forKey: vendorAuthID) == nil {
            let newVendorCode = createVendorCode()
            UserDefaults.standard.set(newVendorCode, forKey: vendorAuthID)
            FirebaseFirestoreManager.shared.setFieldDataForVendor(vendorID: newVendorCode, dataValue: newVendorCode, dataParameter: "vendorCode")
            FirebaseFirestoreManager.shared.setFieldDataForVendor(vendorID: newVendorCode, dataValue: vendorAuthID, dataParameter: "authID")
        }
    }

    /// Creates a random 5-character alphanumeric vendor code
    /// - Returns: The generated vendor code
    private func createVendorCode() -> String {
        let uuid = UUID().uuidString
        return String(uuid.prefix(5))
    }
}

