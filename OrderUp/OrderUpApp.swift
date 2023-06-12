//
//  OrderUpApp.swift
//  OrderUp
//
//  Created by Nana Bonsu on 6/2/23.
//

import SwiftUI

@main
struct OrderUpApp: App {
    
    @StateObject private var persistenceControl = PersistenceController() //can be observed for the proper change
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceControl.container.viewContext)
            //allows us to use environment in the App!!
        }
        .onChange(of: scenePhase) { _ in
            persistenceControl.save()
        }
    }
}
