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
                if  UserDefaults.standard.getCurrentUserLoggedInType() == "None" {
                    UserChoiceView()
                        .onAppear {
                            signUpModel.vendorLoginStatus = false
                    }
                        .navigationDestination(for: ScreenRouter.self) { screen in
                            switch screen {
                            case .VendorScreen:
                                VendorSignUpView()
                            case .CustomerScreen:
                                CustomerSearchandItemDisplayView()
                            case .choiceScreen:
                                UserChoiceView()
                                    .navigationBarBackButtonHidden(true)
                            case .VendorPhoneAuthScreen:
                                PhoneAuthView(userType: "vendor")
                            case .VendorHomeScreen:
                                VendorTabs(selection: VendorTabsScreens.itemsScreen)
                                    .navigationBarBackButtonHidden(true)
                            }
                        }
                   
                } else if(UserDefaults.standard.getCurrentUserLoggedInType() == "Vendor") {
                    //Maybe change this to userDefaults condfition
                    VendorTabs(selection: VendorTabsScreens.itemsScreen)
                }
                    else {
                        CustomerSearchandItemDisplayView()
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



