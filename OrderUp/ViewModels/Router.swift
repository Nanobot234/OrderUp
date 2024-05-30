//
//  NavRouter.swift
//  OrderUp
//
//  Created by Nana Bonsu on 11/7/23.
//

import Foundation
import SwiftUI


//add navigationDestination to root
//then make it go to different places, based on the enum type
//but will still append to the array,


enum ScreenRouter: Codable {
     case VendorScreen,CustomerScreen,choiceScreen,VendorPhoneAuthScreen,VendorHomeScreen
//    
//    func goToView(val:String) -> any View {
//        switch val {
//            case "VendorScreen":
//                return VendorSignUpView()
//            case "CustomerScreen":
//                 return CustomerSearchandItemDisplayView()
//            case "choiceScreen":
//               return UserChoiceView()
//                    .navigationBarBackButtonHidden(true)
//            case "VendorPhoneAuthScreen":
//                return PhoneAuthView(userType: "vendor")
//            case "VendorHomeScreen":
//               return  VendorTabs()
//                    .navigationBarBackButtonHidden(true)
//        default:
//            return UserChoiceView()
//        }
//        }
    }
    
//switch screen {
//case .VendorScreen:
//    VendorSignUpView()
//case .CustomerScreen:
//    CustomerSearchandItemDisplayView()
//case .choiceScreen:
//    UserChoiceView()
//        .navigationBarBackButtonHidden(true)
//case .VendorPhoneAuthScreen:
//    PhoneAuthView(userType: "vendor")
//case .VendorHomeScreen:
//    VendorTabs()
//        .navigationBarBackButtonHidden(true)
//}
//}

class Router: ObservableObject {
    @Published var loginNavPath:NavigationPath 
//        didSet {
//            savePath()
//        }
    
    
    private let savedNavPath = URL.documentsDirectory.appending(path: "SavedNavPath")
    
    //published variable with the enum type!!, then have the navigation
    
    //var root: ScreenRouter = .choiceScreen //the first screen of the navigationPath
    
    init() {
        if let data = try? Data(contentsOf: savedNavPath) {
            if let decodedData = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                loginNavPath = NavigationPath(decodedData)
                return
            }
        }
        loginNavPath = NavigationPath()
    }
    
    func savePath() {
        guard let navrepresentation = loginNavPath.codable else {return }
        
        do {
            let data = try JSONEncoder().encode(navrepresentation)
            try data.write(to: savedNavPath)
        } catch {
            print("Error when saving navigation data")
        }
    }
    
   
//
//    /case .VendorScreen:
//    //    VendorSignUpView()
//    //case .CustomerScreen:
//    //    CustomerSearchandItemDisplayView()
//    //case .choiceScreen:
//    //    UserChoiceView()
//    //        .navigationBarBackButtonHidden(true)
//    //case .VendorPhoneAuthScreen:
//    //    PhoneAuthView(userType: "vendor")
//    //case .VendorHomeScreen:
//    //    VendorTabs()
//    //        .navigationBarBackButtonHidden(true)
//    //}
//
}
