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
    
    @AppStorage("log_Status") var loginStatus = false
    
    
   @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    

    
    @StateObject private var persistenceControl = PersistenceController() //can be observed for the proper change
    @Environment(\.scenePhase) var scenePhase
    @StateObject var signUpModel = SignUpViewModel()
    @StateObject var navRouter = Router()
    
                            
    //@StateObject private var firebaseManager = FirebaseManager()
    var body: some Scene {
        WindowGroup {
            if !signUpModel.loginStatus {
                NavigationStack(path: $navRouter.loginNavPath) {
                    UserChoiceView()
                }
                    .environmentObject(signUpModel)
                    .environmentObject(navRouter)
                      } else {
            MainView()
                .environment(\.managedObjectContext, persistenceControl.container.viewContext)
                .environmentObject(signUpModel)
                .environmentObject(navRouter)
                          //add the environmnt object here for the mainVIew
//
//            //allows us to use environment in the App!!, but after considering, this here should be in main View, then I can confgure firebase!!!
            }
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
        
    

