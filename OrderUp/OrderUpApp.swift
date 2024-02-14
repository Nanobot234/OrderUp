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
    
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    @StateObject private var persistenceControl = PersistenceController() //can be observed for the proper change
    @Environment(\.scenePhase) var scenePhase
    @StateObject var signUpModel = AuthenticationViewModel()
    @StateObject var navRouter = Router()
    
    
  
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navRouter.loginNavPath) {
                if !signUpModel.loginStatus || navRouter.popToRoot {
                    UserChoiceView()
                        .onAppear {
                            navRouter.popToRoot = false
                    }
                   
            } else {
                MainView()
            }
        }
            .environmentObject(signUpModel)
            .environmentObject(navRouter)
            .environment(\.managedObjectContext, persistenceControl.container.viewContext)
            //
            
        }
        .onChange(of: scenePhase) { _ in
            persistenceControl.save()
        }
        
        
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



