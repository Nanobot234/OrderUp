//
//  ViewModelFiles.swift
//  OrderUp
//
//  Created by Nana Bonsu on 7/5/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit
import SwiftUI

class FirebaseFirestoreManager {
    
    @StateObject private var signUpModel = AuthenticationViewModel()
    
    static let shared = FirebaseFirestoreManager()
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference() //the Firebase storage reference for this application
    let vendorCode = UserDefaults.standard.getCurrentVendorCode()
    
    //this is the vendorID autogenerated by Firebase, will be different when using authentication!
    //Check the above error
    
     func uploadNewVendorItem(itemName: String, itemDescription: String,itemPrice:Double,image:UIImage, itemID: String) {
        //check to see if the vendor has a unique vendor code
  
        //the thing is this same image may be in firebase, so i guess, in furture if I have the user id, I will store the image by the itemID? and then delete the itemID image first
       let imageData = image.jpegData(compressionQuality: 0.5)!
        
        let itemPriceString = "\(itemPrice)"
        uploadItemImage(imageData: imageData, itemName: itemName) { imageUrl in
            self.db.collection("Vendors").document(self.vendorCode).collection("Items").document(itemID).setData(["itemName":itemName, "itemDescription":itemDescription, "imageUrl":imageUrl, "itemPrice": itemPriceString])

        }
        
        
        // now after this I should be uploadinf the image and then putting the correct URL in the database
    }
    
     func uploadItemImage(imageData: Data, itemName: String, completion: @escaping (String) -> ()){
        //let testVendorID = UUID().uuidString
        
        let imageRef = storageRef.child("VendorData/" + itemName + ".jpg")
        
        let uploadTasks = imageRef.putData(imageData, metadata: nil) { (metadata, err) in
            guard metadata != nil else {return }
            
            if let err = err {
                print(err.localizedDescription)
            }
        
            imageRef.downloadURL { url, err in
                //make srue you have the right url
                
                guard let downloadUrl = url else {
                    print("Url Not recieved")
                    return  }
                
                    
                completion(downloadUrl.absoluteString)
                //return the url here
            }
        }
        
    }
    
    
    
        //given the vendorID will be gettigng the orders here!!
    func getOrders() {
        
    }
    
    /// Retrieves the vendor code for a given vendor based on the Vendor's ID. If the vendor code doesnt not exist, a new code is created.
    /// - Parameter vendorID: the unique id of the vendor
    /// - Returns: the vendor code
    func getOrCreateVendorCode(vendorID:String,completion: @escaping (String) -> ()) {
        
        //check if he vendor code is there, if not will create it for the ID that is passed in
        let docRef = self.db.collection("Vendors").document(vendorID)
        
        //check here if not in userDefualts
        
        //check first if there is a vendor Code, 
        if(UserDefaults.standard.string(forKey: "personalVendorCode") == nil) {
            
            
            let newVendorCode = self.createVendorCode()
            
            UserDefaults.standard.set(newVendorCode, forKey: "personalVendorCode") //save this into user defaults
            self.setFeildDataForVendor(vendorID: vendorID, dataValue: newVendorCode, dataParameter: "vendorCode") //save to
            completion(newVendorCode)
        }
        //case where
        
        docRef.getDocument { docSnapshot, err in
            if let vendCode = docSnapshot?.get("vendorCode") as? String {
                completion(vendCode) //
            } else {
                //create a vendorCode, then save it to the Firebase, then return it
                
            }
        }
    }
    
    ///  Sets feild data for a particular vendor at the top level
    /// - Parameters:
    ///   - vendorID: the vendorID of the vendor that you want to set.
    ///   - dataValue: <#dataValue description#>
    ///   - dataParameter: <#dataParameter description#>
    func setFeildDataForVendor(vendorID:String, dataValue: String, dataParameter: String) {
        self.db.collection("Vendors").document(self.vendorCode).setData([dataParameter:dataValue])
    }
    

    
     func deleteVendorItem(itemID:String, completion: @escaping (Bool) -> ()) {
        
         let itemRef = db.collection("Vendors").document(self.vendorCode).collection("Items").document(itemID)
        
        itemRef.delete { error in
            if let error = error {
                            print("Error deleting item from Firebase: \(error)")
                            completion(false)
                        } else {
                            print("Item deleted from Firebase successfully.")
                            completion(true)
                        }
        }
    }
    
    
    /// creates a random 5 digit alphamueric vendor code
    /// - Returns: the vendor code
    func createVendorCode() -> String {
        
        let uuid = UUID().uuidString
        let vendorCode = String(uuid.prefix(5))
        return vendorCode
      
    }
    
    
    
    //edit an item in firebase

    
    
   
}