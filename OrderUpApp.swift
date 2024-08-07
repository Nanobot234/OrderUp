//
//  OrderUpApp.swift
//  OrderUp
//
//  Created by Nana Bonsu on 6/2/23.
//

import SwiftUI
import Firebase
import UIKit
import Firebase
import CoreData
//get the current user in firebase!!

//do more work here

@main


struct OrderUpApp: App {
    
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    @StateObject private var persistenceControl = PersistenceController() //can be observed for the proper change
    @Environment(\.scenePhase) var scenePhase
    @StateObject var authModel = AuthenticationViewModel()
    @StateObject var navRouter = Router()
    
    
  
    var body: some Scene {
        WindowGroup {
             //TODO: Add a check condition to check from user defaults if person is logged in
          
                UserChoiceView()
                    .onAppear {
                       //Dont need to sign out user anymore!!!
                   //   authModel.signOutUser()
                    }
                    .environmentObject(authModel)
                    .environmentObject(navRouter)
                    .environment(\.managedObjectContext, persistenceControl.container.viewContext)
                    .environmentObject(persistenceControl)
     
        }

//        .onChange(of: scenePhase) { _ in
//            persistenceControl.save()
//            
//        }
      
    }
    
    
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHadler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
}



