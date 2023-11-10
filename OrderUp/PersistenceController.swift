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
}
