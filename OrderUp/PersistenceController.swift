//
//  PersistenceController.swift
//  OrderUp
//
//  Created by Nana Bonsu on 8/2/23.
//

import Foundation
import CoreData


class PersistenceController: ObservableObject {
    
    let container = NSPersistentContainer(name:"newOrderupModel")
    
   
    
    init() {
        
        let storeDescription = container.persistentStoreDescriptions.first
    //    storeDescription?.setOption(true as NSNumber, forKey: NSPersiststentStoreAll)
        
        container.loadPersistentStores { description, error in
            if error != nil {
                print("Core data has failed. Get it right")
            }
        }
    }
    
    func save() {
        
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
            }
        }
    }
    
    func deletePersistentStore() {
       guard let persistentStoreURL = container.persistentStoreCoordinator.persistentStores.first?.url else {
           return
       }
       let fileManager = FileManager.default
       do {
           try container.persistentStoreCoordinator.destroyPersistentStore(at: persistentStoreURL, type: .sqlite, options: nil)
           
           try fileManager.removeItem(at: persistentStoreURL)
       } catch {
           print("Failed to delete persistent store: \(error)")
       }
   }
    
    
}
