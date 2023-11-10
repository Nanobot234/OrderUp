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
class Router: ObservableObject {
    
    @Published var loginNavPath = NavigationPath()
    
    //published variable with the enum type!!, then have the navigation
    
    var route: ScreenRouter = .choiceScreen //first
    
    enum ScreenRouter {
        case VendorScreen,CustomerScreen,choiceScreen,PhoneAuthScreen
    }
    
    //needt o add navigationStack to the root view
    //then add a destination for each screen, .navigationDestination
    //so , I can use screenRouter with the Viewbuilder to show th next screen needed?
    
}
