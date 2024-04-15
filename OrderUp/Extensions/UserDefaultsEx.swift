//
//  UserDefaults.swift
//  OrderUp
//
//  Created by Nana Bonsu on 2/13/24.
//

import Foundation
import SwiftUI

//provide some useful custom functions for my project frm UserDefaults
extension UserDefaults {
    
    
    /// Returns the current signed in Vendor's vendor code
    
    func getCurrentVendorCode() -> String {
        
        let vendorAuthID = getCurrentVendorAuthID()
        return UserDefaults.standard.string(forKey: vendorAuthID)!
    }
    
    ///  Returns the AuthId of the current vendor thats logged in
   
    
    func setVendorAuthID(vendorAuthID: String) {
        UserDefaults.standard.set(vendorAuthID, forKey: "vendorAuthID")
    }
    func getCurrentVendorAuthID() -> String {
        
        return UserDefaults.standard.string(forKey: "vendorAuthID")!
    }
    
    ///  Check if value exists in userDefaults!
    /// - Parameter key: the key you want to check
    /// - Returns: boolean stating whether value exists for a key
    func valueExists(forKey key: String) -> Bool {
               return object(forKey: key) != nil
           }
    
    func setCurrentUserLoggedInType(userType:String) {
        switch userType {
        case "Customer":
            UserDefaults.standard.set("Customer", forKey: "loggedInUserType")
        case "Vendor":
            UserDefaults.standard.set("Vendor", forKey: "loggedInUserType")
        default:
            return
        }
    }
    
    func getCurrentUserLoggedInType() -> String {
        return UserDefaults.standard.string(forKey: "loggedInUserType") ?? "None"
    }
}
