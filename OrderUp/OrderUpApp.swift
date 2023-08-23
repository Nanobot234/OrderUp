//
//  OrderUpApp.swift
//  OrderUp
//
//  Created by Nana Bonsu on 6/2/23.
//

import SwiftUI
import Firebase
import UIKit




@main


struct OrderUpApp: App {
    
    
    @StateObject private var persistenceControl = PersistenceController() //can be observed for the proper change
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var firebaseManager = FirebaseManager()

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceControl.container.viewContext)
                .environmentObject(firebaseManager)
            //allows us to use environment in the App!!
        }
        
        .onChange(of: scenePhase) { _ in
            persistenceControl.save()
        }
        
    }
        
}
