//
//  PersistenceController.swift
//  OrderUp
//
//  Created by Nana Bonsu on 6/7/23.
//

import Foundation
import CoreData


class PersistenceController: ObservableObject {
    
    let container = NSPersistentContainer(name:"OrderUp")
    
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
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
}
