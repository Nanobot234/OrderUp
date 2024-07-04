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

    private let db = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    private let vendorCode = UserDefaults.standard.getCurrentVendorCode()

    /// Uploads a new vendor item to Firestore with its image
    /// - Parameters:
    ///   - itemName: Name of the item
    ///   - itemDescription: Description of the item
    ///   - itemPrice: Price of the item
    ///   - image: Image of the item
    ///   - itemID: Unique ID of the item
    func uploadNewVendorItem(itemName: String, itemDescription: String, itemPrice: Double, image: UIImage, itemID: String) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let itemPriceString = "\(itemPrice)"

        uploadItemImage(imageData: imageData, itemName: itemName) { imageUrl in
            self.db.collection("Vendors").document(self.vendorCode).collection("Items").document(itemID).setData([
                "itemName": itemName,
                "itemDescription": itemDescription,
                "imageUrl": imageUrl,
                "itemPrice": itemPriceString
            ])
        }
    }

        
    /// Uploads an item image to Firebase Storage and returns the URL
    /// - Parameters:
    ///   - imageData: Data representation of the image
    ///   - itemName: Name of the item
    ///   - completion: Completion handler with the image URL
    func uploadItemImage(imageData: Data, itemName: String, completion: @escaping (String) -> ()) {
        let imageRef = storageRef.child("VendorData/\(itemName).jpg")

        imageRef.putData(imageData, metadata: nil) { metadata, error in
            guard metadata != nil else { return }

            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }

            imageRef.downloadURL { url, error in
                guard let downloadUrl = url else {
                    print("URL not received")
                    return
                }

                completion(downloadUrl.absoluteString)
            }
        }
    }

    /// Retrieves the orders for the current vendor (to be implemented)
    func getOrders() {
        // TODO: Implement order retrieval logic
    }

    /// Sets field data for a particular vendor at the top level
    /// - Parameters:
    ///   - vendorID: The vendor ID
    ///   - dataValue: The value to set
    ///   - dataParameter: The field parameter
    func setFieldDataForVendor(vendorID: String, dataValue: String, dataParameter: String) {
        db.collection("Vendors").document(vendorCode).setData([dataParameter: dataValue])
    }

    /// Deletes a vendor item from Firestore
    /// - Parameters:
    ///   - itemID: Unique ID of the item
    ///   - completion: Completion handler with a success flag
    func deleteVendorItem(itemID: String, completion: @escaping (Bool) -> ()) {
        let itemRef = db.collection("Vendors").document(vendorCode).collection("Items").document(itemID)

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

    /// Retrieves the vendor code based on the vendor's authentication ID
    /// - Parameter vendorAuthID: Authentication ID of the vendor
    func getVendorCodefromAuthID(vendorAuthID: String) {
        db.collection("yourCollectionName")
            .whereField(vendorAuthID, isGreaterThan: NSNull())
            .limit(to: 1)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        break
                    }
                }
            }
    }

    /// Creates a random 5-character alphanumeric vendor code
    /// - Returns: The generated vendor code
    func createVendorCode() -> String {
        let uuid = UUID().uuidString
        return String(uuid.prefix(5))
    }

    // TODO: Add edit item functionality
}

